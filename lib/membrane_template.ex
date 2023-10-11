defmodule Membrane.ArtifactsDemo do
  @moduledoc false

  use Membrane.Pipeline

  alias Membrane.{Pad, RTP, UDP}

  @input_file "big_buck_bunny.h264"
  @port 4000
  @local_address {127, 0, 0, 1}

  @impl true
  def handle_init(_ctx, _opt) do
    spec = [
      child(:video_source, %Membrane.File.Source{
        location: @input_file
      })
      |> child(:parser_video, %Membrane.H264.Parser{
        output_alignment: :nalu,
        generate_best_effort_timestamps: %{framerate: {24, 1}}
      })
      |> child(:realtimer, Membrane.Realtimer)
      |> via_in(Pad.ref(:input, 0),
        options: [payloader: RTP.H264.Payloader]
      )
      |> child(:rtp_payloader, RTP.SessionBin)
      |> via_out(Pad.ref(:rtp_output, 0), options: [encoding: :H264])
      |> child(:upd_sink, %UDP.Sink{
        destination_port_no: @port,
        destination_address: @local_address
      })
    ]

    spec2 = [
      child(:upd_source, %UDP.Source{
        local_port_no: @port,
        local_address: @local_address
      })
      |> via_in(Pad.ref(:rtp_input, 0))
      |> child(:rtp_depayloader, RTP.SessionBin)
    ]

    {[spec: spec, spec: spec2], %{}}
  end

  @impl true
  def handle_child_notification(
        {:new_rtp_stream, ssrc, _pt, _ext},
        :rtp_depayloader,
        _ctx,
        state
      ) do
    spec = [
      get_child(:rtp_depayloader)
      |> via_out(Pad.ref(:output, ssrc), options: [depayloader: RTP.H264.Depayloader])
      |> child(:output_parser, %Membrane.H264.Parser{
        generate_best_effort_timestamps: %{framerate: {24, 1}}
      })
      |> child(:decoder, Membrane.H264.FFmpeg.Decoder)
      |> child(:sdl_player, Membrane.SDL.Player)
    ]

    IO.inspect(:dupa1)

    {[spec: spec], state}
  end

  @impl true
  def handle_child_notification(notification, child, _ctx, state) do
    IO.inspect({child, notification})
    {[], state}
  end
end

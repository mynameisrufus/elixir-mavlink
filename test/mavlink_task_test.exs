defmodule Mavlink.Test.Tasks do
  use ExUnit.Case
  import Mix.Tasks.Mavlink
  
  @input "#{File.cwd!}/test/input/common.xml"
  @output "#{File.cwd!}/test/output/Mavlink.ex"
 
  test "generate" do
    File.rm(@output)
    run([
      "generate",
      @input,
      @output])
    assert File.exists?(@output)
    pairs = Enum.zip([
      Elixir.Mavlink,
      Elixir.Mavlink.ActuatorControlTarget,
      Elixir.Mavlink.AdsbVehicle,
      Elixir.Mavlink.Altitude,
      Elixir.Mavlink.AttPosMocap,
      Elixir.Mavlink.Attitude,
      Elixir.Mavlink.AttitudeQuaternion,
      Elixir.Mavlink.AttitudeQuaternionCov,
      Elixir.Mavlink.AttitudeTarget,
      Elixir.Mavlink.AuthKey,
      Elixir.Mavlink.AutopilotVersion,
      Elixir.Mavlink.BatteryStatus,
      Elixir.Mavlink.ButtonChange,
      Elixir.Mavlink.CameraCaptureStatus,
      Elixir.Mavlink.CameraImageCaptured,
      Elixir.Mavlink.CameraInformation,
      Elixir.Mavlink.CameraSettings,
      Elixir.Mavlink.CameraTrigger,
      Elixir.Mavlink.ChangeOperatorControl,
      Elixir.Mavlink.ChangeOperatorControlAck,
      Elixir.Mavlink.Collision,
      Elixir.Mavlink.CommandAck,
      Elixir.Mavlink.CommandInt,
      Elixir.Mavlink.CommandLong,
      Elixir.Mavlink.ControlSystemState,
      Elixir.Mavlink.DataStream,
      Elixir.Mavlink.DataTransmissionHandshake,
      Elixir.Mavlink.Debug,
      Elixir.Mavlink.DebugFloatArray,
      Elixir.Mavlink.DebugVect,
      Elixir.Mavlink.DistanceSensor,
      Elixir.Mavlink.EncapsulatedData,
      Elixir.Mavlink.EstimatorStatus,
      Elixir.Mavlink.ExtendedSysState,
      Elixir.Mavlink.FileTransferProtocol,
      Elixir.Mavlink.FlightInformation,
      Elixir.Mavlink.FollowTarget,
      Elixir.Mavlink.GlobalPositionInt,
      Elixir.Mavlink.GlobalPositionIntCov,
      Elixir.Mavlink.GlobalVisionPositionEstimate,
      Elixir.Mavlink.Gps2Raw,
      Elixir.Mavlink.Gps2Rtk,
      Elixir.Mavlink.GpsGlobalOrigin,
      Elixir.Mavlink.GpsInjectData,
      Elixir.Mavlink.GpsInput,
      Elixir.Mavlink.GpsRawInt,
      Elixir.Mavlink.GpsRtcmData,
      Elixir.Mavlink.GpsRtk,
      Elixir.Mavlink.GpsStatus,
      Elixir.Mavlink.Heartbeat,
      Elixir.Mavlink.HighLatency,
      Elixir.Mavlink.HighresImu,
      Elixir.Mavlink.HilActuatorControls,
      Elixir.Mavlink.HilControls,
      Elixir.Mavlink.HilGps,
      Elixir.Mavlink.HilOpticalFlow,
      Elixir.Mavlink.HilRcInputsRaw,
      Elixir.Mavlink.HilSensor,
      Elixir.Mavlink.HilState,
      Elixir.Mavlink.HilStateQuaternion,
      Elixir.Mavlink.HomePosition,
      Elixir.Mavlink.LandingTarget,
      Elixir.Mavlink.LocalPositionNed,
      Elixir.Mavlink.LocalPositionNedCov,
      Elixir.Mavlink.LocalPositionNedSystemGlobalOffset,
      Elixir.Mavlink.LogData,
      Elixir.Mavlink.LogEntry,
      Elixir.Mavlink.LogErase,
      Elixir.Mavlink.LogRequestData,
      Elixir.Mavlink.LogRequestEnd,
      Elixir.Mavlink.LogRequestList,
      Elixir.Mavlink.LoggingAck,
      Elixir.Mavlink.LoggingData,
      Elixir.Mavlink.LoggingDataAcked,
      Elixir.Mavlink.ManualControl,
      Elixir.Mavlink.ManualSetpoint,
      Elixir.Mavlink.MemoryVect,
      Elixir.Mavlink.MessageInterval,
      Elixir.Mavlink.MissionAck,
      Elixir.Mavlink.MissionClearAll,
      Elixir.Mavlink.MissionCount,
      Elixir.Mavlink.MissionCurrent,
      Elixir.Mavlink.MissionItem,
      Elixir.Mavlink.MissionItemInt,
      Elixir.Mavlink.MissionItemReached,
      Elixir.Mavlink.MissionRequest,
      Elixir.Mavlink.MissionRequestInt,
      Elixir.Mavlink.MissionRequestList,
      Elixir.Mavlink.MissionRequestPartialList,
      Elixir.Mavlink.MissionSetCurrent,
      Elixir.Mavlink.MissionWritePartialList,
      Elixir.Mavlink.MountOrientation,
      Elixir.Mavlink.NamedValueFloat,
      Elixir.Mavlink.NamedValueInt,
      Elixir.Mavlink.NavControllerOutput,
      Elixir.Mavlink.ObstacleDistance,
      Elixir.Mavlink.Odometry,
      Elixir.Mavlink.OpticalFlow,
      Elixir.Mavlink.OpticalFlowRad,
      Elixir.Mavlink.Pack,
      Elixir.Mavlink.Pack.Atom,
      Elixir.Mavlink.Pack.BitString,
      Elixir.Mavlink.Pack.Float,
      Elixir.Mavlink.Pack.Function,
      Elixir.Mavlink.Pack.Integer,
      Elixir.Mavlink.Pack.List,
      Elixir.Mavlink.Pack.Map,
      Elixir.Mavlink.Pack.Mavlink.ActuatorControlTarget,
      Elixir.Mavlink.Pack.Mavlink.AdsbVehicle,
      Elixir.Mavlink.Pack.Mavlink.Altitude,
      Elixir.Mavlink.Pack.Mavlink.AttPosMocap,
      Elixir.Mavlink.Pack.Mavlink.Attitude,
      Elixir.Mavlink.Pack.Mavlink.AttitudeQuaternion,
      Elixir.Mavlink.Pack.Mavlink.AttitudeQuaternionCov,
      Elixir.Mavlink.Pack.Mavlink.AttitudeTarget,
      Elixir.Mavlink.Pack.Mavlink.AuthKey,
      Elixir.Mavlink.Pack.Mavlink.AutopilotVersion,
      Elixir.Mavlink.Pack.Mavlink.BatteryStatus,
      Elixir.Mavlink.Pack.Mavlink.ButtonChange,
      Elixir.Mavlink.Pack.Mavlink.CameraCaptureStatus,
      Elixir.Mavlink.Pack.Mavlink.CameraImageCaptured,
      Elixir.Mavlink.Pack.Mavlink.CameraInformation,
      Elixir.Mavlink.Pack.Mavlink.CameraSettings,
      Elixir.Mavlink.Pack.Mavlink.CameraTrigger,
      Elixir.Mavlink.Pack.Mavlink.ChangeOperatorControl,
      Elixir.Mavlink.Pack.Mavlink.ChangeOperatorControlAck,
      Elixir.Mavlink.Pack.Mavlink.Collision,
      Elixir.Mavlink.Pack.Mavlink.CommandAck,
      Elixir.Mavlink.Pack.Mavlink.CommandInt,
      Elixir.Mavlink.Pack.Mavlink.CommandLong,
      Elixir.Mavlink.Pack.Mavlink.ControlSystemState,
      Elixir.Mavlink.Pack.Mavlink.DataStream,
      Elixir.Mavlink.Pack.Mavlink.DataTransmissionHandshake,
      Elixir.Mavlink.Pack.Mavlink.Debug,
      Elixir.Mavlink.Pack.Mavlink.DebugFloatArray,
      Elixir.Mavlink.Pack.Mavlink.DebugVect,
      Elixir.Mavlink.Pack.Mavlink.DistanceSensor,
      Elixir.Mavlink.Pack.Mavlink.EncapsulatedData,
      Elixir.Mavlink.Pack.Mavlink.EstimatorStatus,
      Elixir.Mavlink.Pack.Mavlink.ExtendedSysState,
      Elixir.Mavlink.Pack.Mavlink.FileTransferProtocol,
      Elixir.Mavlink.Pack.Mavlink.FlightInformation,
      Elixir.Mavlink.Pack.Mavlink.FollowTarget,
      Elixir.Mavlink.Pack.Mavlink.GlobalPositionInt,
      Elixir.Mavlink.Pack.Mavlink.GlobalPositionIntCov,
      Elixir.Mavlink.Pack.Mavlink.GlobalVisionPositionEstimate,
      Elixir.Mavlink.Pack.Mavlink.Gps2Raw,
      Elixir.Mavlink.Pack.Mavlink.Gps2Rtk,
      Elixir.Mavlink.Pack.Mavlink.GpsGlobalOrigin,
      Elixir.Mavlink.Pack.Mavlink.GpsInjectData,
      Elixir.Mavlink.Pack.Mavlink.GpsInput,
      Elixir.Mavlink.Pack.Mavlink.GpsRawInt,
      Elixir.Mavlink.Pack.Mavlink.GpsRtcmData,
      Elixir.Mavlink.Pack.Mavlink.GpsRtk,
      Elixir.Mavlink.Pack.Mavlink.GpsStatus,
      Elixir.Mavlink.Pack.Mavlink.Heartbeat,
      Elixir.Mavlink.Pack.Mavlink.HighLatency,
      Elixir.Mavlink.Pack.Mavlink.HighresImu,
      Elixir.Mavlink.Pack.Mavlink.HilActuatorControls,
      Elixir.Mavlink.Pack.Mavlink.HilControls,
      Elixir.Mavlink.Pack.Mavlink.HilGps,
      Elixir.Mavlink.Pack.Mavlink.HilOpticalFlow,
      Elixir.Mavlink.Pack.Mavlink.HilRcInputsRaw,
      Elixir.Mavlink.Pack.Mavlink.HilSensor,
      Elixir.Mavlink.Pack.Mavlink.HilState,
      Elixir.Mavlink.Pack.Mavlink.HilStateQuaternion,
      Elixir.Mavlink.Pack.Mavlink.HomePosition,
      Elixir.Mavlink.Pack.Mavlink.LandingTarget,
      Elixir.Mavlink.Pack.Mavlink.LocalPositionNed,
      Elixir.Mavlink.Pack.Mavlink.LocalPositionNedCov,
      Elixir.Mavlink.Pack.Mavlink.LocalPositionNedSystemGlobalOffset,
      Elixir.Mavlink.Pack.Mavlink.LogData,
      Elixir.Mavlink.Pack.Mavlink.LogEntry,
      Elixir.Mavlink.Pack.Mavlink.LogErase,
      Elixir.Mavlink.Pack.Mavlink.LogRequestData,
      Elixir.Mavlink.Pack.Mavlink.LogRequestEnd,
      Elixir.Mavlink.Pack.Mavlink.LogRequestList,
      Elixir.Mavlink.Pack.Mavlink.LoggingAck,
      Elixir.Mavlink.Pack.Mavlink.LoggingData,
      Elixir.Mavlink.Pack.Mavlink.LoggingDataAcked,
      Elixir.Mavlink.Pack.Mavlink.ManualControl,
      Elixir.Mavlink.Pack.Mavlink.ManualSetpoint,
      Elixir.Mavlink.Pack.Mavlink.MemoryVect,
      Elixir.Mavlink.Pack.Mavlink.MessageInterval,
      Elixir.Mavlink.Pack.Mavlink.MissionAck,
      Elixir.Mavlink.Pack.Mavlink.MissionClearAll,
      Elixir.Mavlink.Pack.Mavlink.MissionCount,
      Elixir.Mavlink.Pack.Mavlink.MissionCurrent,
      Elixir.Mavlink.Pack.Mavlink.MissionItem,
      Elixir.Mavlink.Pack.Mavlink.MissionItemInt,
      Elixir.Mavlink.Pack.Mavlink.MissionItemReached,
      Elixir.Mavlink.Pack.Mavlink.MissionRequest,
      Elixir.Mavlink.Pack.Mavlink.MissionRequestInt,
      Elixir.Mavlink.Pack.Mavlink.MissionRequestList,
      Elixir.Mavlink.Pack.Mavlink.MissionRequestPartialList,
      Elixir.Mavlink.Pack.Mavlink.MissionSetCurrent,
      Elixir.Mavlink.Pack.Mavlink.MissionWritePartialList,
      Elixir.Mavlink.Pack.Mavlink.MountOrientation,
      Elixir.Mavlink.Pack.Mavlink.NamedValueFloat,
      Elixir.Mavlink.Pack.Mavlink.NamedValueInt,
      Elixir.Mavlink.Pack.Mavlink.NavControllerOutput,
      Elixir.Mavlink.Pack.Mavlink.ObstacleDistance,
      Elixir.Mavlink.Pack.Mavlink.Odometry,
      Elixir.Mavlink.Pack.Mavlink.OpticalFlow,
      Elixir.Mavlink.Pack.Mavlink.OpticalFlowRad,
      Elixir.Mavlink.Pack.Mavlink.ParamMapRc,
      Elixir.Mavlink.Pack.Mavlink.ParamRequestList,
      Elixir.Mavlink.Pack.Mavlink.ParamRequestRead,
      Elixir.Mavlink.Pack.Mavlink.ParamSet,
      Elixir.Mavlink.Pack.Mavlink.ParamValue,
      Elixir.Mavlink.Pack.Mavlink.Ping,
      Elixir.Mavlink.Pack.Mavlink.PlayTune,
      Elixir.Mavlink.Pack.Mavlink.PositionTargetGlobalInt,
      Elixir.Mavlink.Pack.Mavlink.PositionTargetLocalNed,
      Elixir.Mavlink.Pack.Mavlink.PowerStatus,
      Elixir.Mavlink.Pack.Mavlink.RadioStatus,
      Elixir.Mavlink.Pack.Mavlink.RawImu,
      Elixir.Mavlink.Pack.Mavlink.RawPressure,
      Elixir.Mavlink.Pack.Mavlink.RcChannels,
      Elixir.Mavlink.Pack.Mavlink.RcChannelsOverride,
      Elixir.Mavlink.Pack.Mavlink.RcChannelsRaw,
      Elixir.Mavlink.Pack.Mavlink.RcChannelsScaled,
      Elixir.Mavlink.Pack.Mavlink.RequestDataStream,
      Elixir.Mavlink.Pack.Mavlink.ResourceRequest,
      Elixir.Mavlink.Pack.Mavlink.SafetyAllowedArea,
      Elixir.Mavlink.Pack.Mavlink.SafetySetAllowedArea,
      Elixir.Mavlink.Pack.Mavlink.ScaledImu,
      Elixir.Mavlink.Pack.Mavlink.ScaledImu2,
      Elixir.Mavlink.Pack.Mavlink.ScaledImu3,
      Elixir.Mavlink.Pack.Mavlink.ScaledPressure,
      Elixir.Mavlink.Pack.Mavlink.ScaledPressure2,
      Elixir.Mavlink.Pack.Mavlink.ScaledPressure3,
      Elixir.Mavlink.Pack.Mavlink.SerialControl,
      Elixir.Mavlink.Pack.Mavlink.ServoOutputRaw,
      Elixir.Mavlink.Pack.Mavlink.SetActuatorControlTarget,
      Elixir.Mavlink.Pack.Mavlink.SetAttitudeTarget,
      Elixir.Mavlink.Pack.Mavlink.SetGpsGlobalOrigin,
      Elixir.Mavlink.Pack.Mavlink.SetHomePosition,
      Elixir.Mavlink.Pack.Mavlink.SetMode,
      Elixir.Mavlink.Pack.Mavlink.SetPositionTargetGlobalInt,
      Elixir.Mavlink.Pack.Mavlink.SetPositionTargetLocalNed,
      Elixir.Mavlink.Pack.Mavlink.SetupSigning,
      Elixir.Mavlink.Pack.Mavlink.SimState,
      Elixir.Mavlink.Pack.Mavlink.Statustext,
      Elixir.Mavlink.Pack.Mavlink.StatustextLong,
      Elixir.Mavlink.Pack.Mavlink.StorageInformation,
      Elixir.Mavlink.Pack.Mavlink.SysStatus,
      Elixir.Mavlink.Pack.Mavlink.SystemTime,
      Elixir.Mavlink.Pack.Mavlink.TerrainCheck,
      Elixir.Mavlink.Pack.Mavlink.TerrainData,
      Elixir.Mavlink.Pack.Mavlink.TerrainReport,
      Elixir.Mavlink.Pack.Mavlink.TerrainRequest,
      Elixir.Mavlink.Pack.Mavlink.Timesync,
      Elixir.Mavlink.Pack.Mavlink.UavcanNodeInfo,
      Elixir.Mavlink.Pack.Mavlink.UavcanNodeStatus,
      Elixir.Mavlink.Pack.Mavlink.V2Extension,
      Elixir.Mavlink.Pack.Mavlink.VfrHud,
      Elixir.Mavlink.Pack.Mavlink.Vibration,
      Elixir.Mavlink.Pack.Mavlink.ViconPositionEstimate,
      Elixir.Mavlink.Pack.Mavlink.VisionPositionEstimate,
      Elixir.Mavlink.Pack.Mavlink.VisionSpeedEstimate,
      Elixir.Mavlink.Pack.Mavlink.WheelDistance,
      Elixir.Mavlink.Pack.Mavlink.WifiConfigAp,
      Elixir.Mavlink.Pack.Mavlink.WindCov,
      Elixir.Mavlink.Pack.PID,
      Elixir.Mavlink.Pack.Port,
      Elixir.Mavlink.Pack.Reference,
      Elixir.Mavlink.Pack.Tuple,
      Elixir.Mavlink.ParamMapRc,
      Elixir.Mavlink.ParamRequestList,
      Elixir.Mavlink.ParamRequestRead,
      Elixir.Mavlink.ParamSet,
      Elixir.Mavlink.ParamValue,
      Elixir.Mavlink.Ping,
      Elixir.Mavlink.PlayTune,
      Elixir.Mavlink.PositionTargetGlobalInt,
      Elixir.Mavlink.PositionTargetLocalNed,
      Elixir.Mavlink.PowerStatus,
      Elixir.Mavlink.RadioStatus,
      Elixir.Mavlink.RawImu,
      Elixir.Mavlink.RawPressure,
      Elixir.Mavlink.RcChannels,
      Elixir.Mavlink.RcChannelsOverride,
      Elixir.Mavlink.RcChannelsRaw,
      Elixir.Mavlink.RcChannelsScaled,
      Elixir.Mavlink.RequestDataStream,
      Elixir.Mavlink.ResourceRequest,
      Elixir.Mavlink.SafetyAllowedArea,
      Elixir.Mavlink.SafetySetAllowedArea,
      Elixir.Mavlink.ScaledImu,
      Elixir.Mavlink.ScaledImu2,
      Elixir.Mavlink.ScaledImu3,
      Elixir.Mavlink.ScaledPressure,
      Elixir.Mavlink.ScaledPressure2,
      Elixir.Mavlink.ScaledPressure3,
      Elixir.Mavlink.SerialControl,
      Elixir.Mavlink.ServoOutputRaw,
      Elixir.Mavlink.SetActuatorControlTarget,
      Elixir.Mavlink.SetAttitudeTarget,
      Elixir.Mavlink.SetGpsGlobalOrigin,
      Elixir.Mavlink.SetHomePosition,
      Elixir.Mavlink.SetMode,
      Elixir.Mavlink.SetPositionTargetGlobalInt,
      Elixir.Mavlink.SetPositionTargetLocalNed,
      Elixir.Mavlink.SetupSigning,
      Elixir.Mavlink.SimState,
      Elixir.Mavlink.Statustext,
      Elixir.Mavlink.StatustextLong,
      Elixir.Mavlink.StorageInformation,
      Elixir.Mavlink.SysStatus,
      Elixir.Mavlink.SystemTime,
      Elixir.Mavlink.TerrainCheck,
      Elixir.Mavlink.TerrainData,
      Elixir.Mavlink.TerrainReport,
      Elixir.Mavlink.TerrainRequest,
      Elixir.Mavlink.Timesync,
      Elixir.Mavlink.UavcanNodeInfo,
      Elixir.Mavlink.UavcanNodeStatus,
      Elixir.Mavlink.V2Extension,
      Elixir.Mavlink.VfrHud,
      Elixir.Mavlink.Vibration,
      Elixir.Mavlink.ViconPositionEstimate,
      Elixir.Mavlink.VisionPositionEstimate,
      Elixir.Mavlink.VisionSpeedEstimate,
      Elixir.Mavlink.WheelDistance,
      Elixir.Mavlink.WifiConfigAp,
      Elixir.Mavlink.WindCov],
      Code.compile_file(@output)
      |> Keyword.keys()
      |> Enum.sort())
    
    for {expected, actual} <- pairs do
      assert expected == actual
    end
  end
  
end

_:
{
  # Uses upstream rpi-poe-fan driver (firmware mailbox, not fwpwm)
  hardware.deviceTree.overlays = [
    {
      name = "rpi-poe-plus";
      dtboFile = null;
      dtsText = ''
        /dts-v1/;
        /plugin/;

        / {
          compatible = "brcm,bcm2711";

          fragment@0 {
            target = <&firmware>;
            __overlay__ {
              fan: rpi-poe-fan {
                compatible = "raspberrypi,rpi-poe-fan";
                cooling-levels = <0 32 64 128 255>;
                #cooling-cells = <2>;
              };
            };
          };

          fragment@1 {
            target = <&cpu_thermal>;
            __overlay__ {
              polling-delay = <2000>;
              trips {
                trip0: trip0 {
                  temperature = <40000>;
                  hysteresis = <2000>;
                  type = "active";
                };
                trip1: trip1 {
                  temperature = <45000>;
                  hysteresis = <2000>;
                  type = "active";
                };
                trip2: trip2 {
                  temperature = <50000>;
                  hysteresis = <2000>;
                  type = "active";
                };
                trip3: trip3 {
                  temperature = <55000>;
                  hysteresis = <5000>;
                  type = "active";
                };
              };
              cooling-maps {
                map0 {
                  trip = <&trip0>;
                  cooling-device = <&fan 0 1>;
                };
                map1 {
                  trip = <&trip1>;
                  cooling-device = <&fan 1 2>;
                };
                map2 {
                  trip = <&trip2>;
                  cooling-device = <&fan 2 3>;
                };
                map3 {
                  trip = <&trip3>;
                  cooling-device = <&fan 3 4>;
                };
              };
            };
          };
        };
      '';
    }
  ];
}

FROM fedora:38 as base-appimage-dir
RUN dnf update -y
RUN dnf install -y file p7zip p7zip-plugins

RUN dnf --installroot=/inkscape-linux/ --nodocs --releasever=/ --setopt install_weak_deps=false install -y inkscape-1.2.2-7.fc38
COPY AppRun /inkscape-linux/
RUN chmod +x /inkscape-linux/AppRun
RUN ln -s /inkscape-linux/usr/share/applications/org.inkscape.Inkscape.desktop /inkscape-linux/org.inkscape.Inkscape.desktop
COPY org.inkscape.Inkscape.png /inkscape-linux/org.inkscape.Inkscape.png

ADD https://inkscape.org/gallery/item/37364/inkscape-1.2.2_2022-12-09_732a01da63-x64.7z \
    https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage ./

RUN chmod +x appimagetool-x86_64.AppImage

RUN 7z x inkscape-1.2.2_2022-12-09_732a01da63-x64.7z && mv inkscape-1.2.2_2022-12-09_732a01da63-x64 inkscape-win

# Update parser parameters
RUN sed -i 's/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False)/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False, recover=True)/' /inkscape-linux/usr/share/inkscape/extensions/inkex/elements/_parser.py
RUN sed -i 's/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False)/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False, recover=True)/' inkscape-win/share/inkscape/extensions/inkex/elements/_parser.py

# Getnerate ./Inkscape-x86_64.AppImage
RUN ./appimagetool-x86_64.AppImage --appimage-extract-and-run -n /inkscape-linux/

# Test inkscape
# RUN ./Inkscape-x86_64.AppImage --appimage-extract-and-run --version && exit 1
# ADD https://s3.us-east-2.amazonaws.com/dev.mydesigns.io/design/tmp/a5d3cc3e-b210-463b-aeec-77cbaa7cb455.svg?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEOn%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDGV1LWNlbnRyYWwtMSJHMEUCIEsZX7qYu5raHJfmZ%2BNuaoCcx7J7k5fBGysFfQSqzaDKAiEApGabJovHQ8sH7%2B599nAMhRps2nqltbAgVhQyXTJa8a8qgQMIQhADGgw5NjMwNjU5MjQzMzMiDO%2Bq0UKuHVVW2HUwlyreAiJB8vUCzAX0%2Fiap%2B%2F5Fm4q9En9%2FSWEhoP1Cb8D386IM1ytWKyky8OMMkaEpV2oAa4WMZnFMnr0SLE2i%2FKe1oJxyFhFXWNkRGcM9NY32nQUO29%2B7ijFi1vFx2YUA%2B4VQk%2FD4WbYn1cKx4CxV%2FNGMNx%2FLNuHu8uyerqAkuy47IpRQ76%2BSnoXYx9YOtJXK%2FlexCds6G08wtrXoRFCmQMG3oPI%2BpsGDanVQAw576j6XmjOkIkBHqSHh9u4vvwo5k2K3tBIrwTfo0XCcnkjETvQ8CyHhMf2uXM2XUAupVunrByeYEGIr5GDO%2Bn2vR8fIlAwBiJ9infKOM%2BVnY%2Fbm6Pa2QwsfU3JzYszt%2F%2B%2FPXhgrcA53SbjUOSZvNTQZaBPJXFncK8UvUddlCRzMx%2FilFea3ycALECViRIIMUqe2chduJp4Myz8IbkGPXvb6zQO6cZm53i199e9eQJQs5qXcAKHlMIzAsKQGOrMC566YqHd3bZdRQ4Y5zRyBhUsmFo65ZViThCrbI34zD1jjuZNlqQmlQhHfU3G1JPdq8PD44vR%2B0ZO%2BtjsfGEC0wzRkkMRbMNAkw26pIZzL86IeDS3DKZI2SFihBWMgVSqRtxbXP3HaUNSVZIjUBWm0J2N34q7HbVz0FF5LmGQxE0aAa%2B40rEEXRMEH3QDyXL%2BHBmhHFreGHO401rePnaZzczoJ716COdnZRUhHlhBDNSSqnqFiCT2vRBXnMBKdJQDiRAkG65fRW%2BrvfRjmdc2KAh%2B6glgVa1V2S%2FB%2FeLZF2zBQTGDpTXcXsg%2Bi8NQHyxrBc2qTTWhEsRgsPOct2ERE8xOvUWEuCkzCl1Wa2xV3tJydfnoNMAFB86ynozliC6Nk%2Bb5aoGVEEsTsrtxCZrf9%2Be52aA%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230616T084718Z&X-Amz-SignedHeaders=host&X-Amz-Expires=43200&X-Amz-Credential=ASIA6AOZTZLW4FASD3NA%2F20230616%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Signature=b0dba28c1cbd537f67ba94a8ba8e552d13f755512f08b70a5d7c61abf037c331 a5d3cc3e-b210-463b-aeec-77cbaa7cb455.svg
# RUN cat a5d3cc3e-b210-463b-aeec-77cbaa7cb455.svg | /inkscape-linux/AppRun --export-type=png --pipe | /inkscape-linux/bin/base64 && exit 1

ENTRYPOINT cp Inkscape-x86_64.AppImage /dest \
    && cp -pr inkscape-win /dest

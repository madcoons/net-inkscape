FROM ubuntu:22.04
RUN apt-get update -y && apt-get -y install file p7zip-full

ADD https://inkscape.org/gallery/item/37359/Inkscape-b0a8486-x86_64.AppImage \
    https://inkscape.org/gallery/item/37364/inkscape-1.2.2_2022-12-09_732a01da63-x64.7z \
    https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage ./

RUN chmod +x Inkscape-b0a8486-x86_64.AppImage
RUN chmod +x appimagetool-x86_64.AppImage

RUN ./Inkscape-b0a8486-x86_64.AppImage --appimage-extract

RUN 7z x inkscape-1.2.2_2022-12-09_732a01da63-x64.7z && mv inkscape-1.2.2_2022-12-09_732a01da63-x64 inkscape-win

# RUN ls -l inkscape-win/share/inkscape/extensions/inkex/elements && exit 1

# RUN cat squashfs-root/AppRun && exit 1
# RUN ls -l squashfs-root/usr/bin/ && exit 1

RUN sed -i 's/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False)/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False, recover=True)/' squashfs-root/usr/share/inkscape/extensions/inkex/elements/_parser.py
RUN sed -i 's/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False)/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False, recover=True)/' inkscape-win/share/inkscape/extensions/inkex/elements/_parser.py

RUN #cat squashfs-root/usr/share/inkscape/extensions/inkex/base.py && exit 1

# Issue: https://gitlab.com/inkscape/inkscape/-/issues/2969
RUN apt-get download shared-mime-info
RUN find *.deb -exec dpkg-deb -x {} squashfs-root/ \;
RUN find *.deb -delete

RUN ./appimagetool-x86_64.AppImage --appimage-extract-and-run squashfs-root/
#RUN ls -l && exit 1

# RUN ./Inkscape-x86_64.AppImage --appimage-extract-and-run --version && exit 1
# RUN ./Inkscape-x86_64.AppImage --appimage-extract-and-run python3.8 -c 'print("hello from python")' && exit 1

ENTRYPOINT cp Inkscape-x86_64.AppImage /dest \
    && cp -pr inkscape-win /dest

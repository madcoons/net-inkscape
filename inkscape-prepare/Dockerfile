FROM debian:bookworm-slim as build

RUN apt-get update -y
RUN apt-get install -y inkscape
# RUN rm -rf /var/cache/* /var/lib/apt/lists/*

# RUN inkscape --version && exit 1

FROM debian:bookworm-slim as inkscape-root

COPY --from=build / /inkscape-root

# AppImage specific files
COPY AppRun /inkscape-root/
RUN chmod a+x /inkscape-root/AppRun
RUN ln -s usr/share/applications/org.inkscape.Inkscape.desktop /inkscape-root/org.inkscape.Inkscape.desktop
RUN ln -s usr/share/icons/hicolor/256x256/apps/org.inkscape.Inkscape.png /inkscape-root/org.inkscape.Inkscape.png
COPY python-update.sh .
RUN (cd /inkscape-root && ../python-update.sh)

# RUN ls -l /inkscape-root/bin/python* && exit 1
# RUN cat /inkscape-root/bin/python3 && exit 1

# Remove unused dirs
RUN rm -rf \
    inkscape-root/boot \
    inkscape-root/dev \
    inkscape-root/home \
    inkscape-root/media \
    inkscape-root/mnt \
    inkscape-root/opt \
    inkscape-root/proc \
    inkscape-root/srv \
    inkscape-root/sys \
    inkscape-root/tmp \
    inkscape-root/root \
    inkscape-root/run \
    inkscape-root/var

# Remove not default icons
RUN rm -rf \
    /inkscape-root/usr/share/icons/Adwaita \
    /inkscape-root/usr/share/icons/default

# Remove python cache
RUN find /inkscape-root/ | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf

# Check size
# RUN du -sh -- inkscape-root/*  | sort -rh && exit 1

# RUN mkdir -p /usr/share/inkscape/ui/ && cp /inkscape-root/usr/share/inkscape/ui/units.xml /usr/share/inkscape/ui/
# RUN /inkscape-root/AppRun --version && exit 1
# RUN ls -l /inkscape-root/usr/share/inkscape/ui/units.xml && exit 1
# RUN ls -l /inkscape-root/bin/ && exit 1

# Fix blas
RUN ln -sf ../../../etc/alternatives/libblas.so.3-x86_64-linux-gnu /inkscape-root/usr/lib/x86_64-linux-gnu/libblas.so.3
RUN ln -sf ../../usr/lib/x86_64-linux-gnu/blas/libblas.so.3 /inkscape-root/etc/alternatives/libblas.so.3-x86_64-linux-gnu

# Fix lapack
RUN ln -sf ../../../etc/alternatives/liblapack.so.3-x86_64-linux-gnu /inkscape-root/usr/lib/x86_64-linux-gnu/liblapack.so.3
RUN ln -sf ../../usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3 /inkscape-root/etc/alternatives/liblapack.so.3-x86_64-linux-gnu

# Testing
# ADD https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/alphachannel.svg alphachannel.svg
# RUN /inkscape-root/AppRun --version && exit 1
# RUN cat alphachannel.svg | /inkscape-root/AppRun --export-type=png --pipe | base64 && exit 1
# RUN cat alphachannel.svg | /inkscape-root/AppRun python3.11 /inkscape-root/usr/share/inkscape/extensions/docinfo.py && exit 1
# RUN /inkscape-root/AppRun --export-type=dxf alphachannel.svg && exit 1

FROM debian:bookworm-slim

RUN apt-get update -y && apt-get install -y p7zip-full file gnupg2

ADD https://inkscape.org/gallery/item/37364/inkscape-1.2.2_2022-12-09_732a01da63-x64.7z \
    https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage ./
RUN chmod +x appimagetool-x86_64.AppImage

RUN 7z x inkscape-1.2.2_2022-12-09_732a01da63-x64.7z && mv inkscape-1.2.2_2022-12-09_732a01da63-x64 inkscape-win
COPY --from=inkscape-root /inkscape-root /inkscape-linux

# Update parser parameters
RUN sed -i 's/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False)/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False, recover=True)/' /inkscape-linux/usr/share/inkscape/extensions/inkex/elements/_parser.py
RUN sed -i 's/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False)/SVG_PARSER = etree.XMLParser(huge_tree=True, strip_cdata=False, recover=True)/' inkscape-win/share/inkscape/extensions/inkex/elements/_parser.py

RUN ./appimagetool-x86_64.AppImage --appimage-extract-and-run -n /inkscape-linux/

ENTRYPOINT cp Inkscape-x86_64.AppImage /dest \
    && cp -pr inkscape-win /dest

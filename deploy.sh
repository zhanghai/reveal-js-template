#!/bin/bash

rm -rf deploy/
mkdir deploy/

cat >deploy/mark-reveal-js-status.sh <<EOF
#!/bin/bash
git -C "$(realpath .)" submodule status reveal.js >.reveal-js-status
EOF
chmod +x deploy/mark-reveal-js-status.sh

cat >deploy/new-reveal-js-presentation.sh <<EOF
#!/bin/bash
dir="\$(if [[ -n "\$1" ]]; then echo "\$1"; else echo .; fi)/\$(if [[ -n "\$2" ]]; then echo "\$2"; else echo presentation; fi)"
cp -r "$(realpath deploy/presentation-template/)" "\${dir}/"
cd "\${dir}/"
./mark-reveal-js-status.sh
EOF
chmod +x deploy/new-reveal-js-presentation.sh

mkdir deploy/presentation-template/
for file in reveal.js/{css,js,lib,node_modules,plugin,Gruntfile.js,package.json}; do
    ln -s "$(realpath "${file}")" deploy/presentation-template/
done
cp reveal.js/index.html deploy/presentation-template/
ln -s "$(realpath deploy/mark-reveal-js-status.sh)" deploy/presentation-template/

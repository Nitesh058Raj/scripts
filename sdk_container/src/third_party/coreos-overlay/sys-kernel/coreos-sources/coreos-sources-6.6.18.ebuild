# Copyright 2014 CoreOS, Inc.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ETYPE="sources"

# -rc releases should be versioned L.M_rcN
# Final releases should be versioned L.M.N, even for N == 0

# Only needed for RCs
K_BASE_VER="5.15"

inherit kernel-2
EXTRAVERSION="-flatcar"
detect_version

DESCRIPTION="Full sources for the CoreOS Linux kernel"
HOMEPAGE="http://www.kernel.org"
if [[ "${PV%%_rc*}" != "${PV}" ]]; then
	SRC_URI="https://git.kernel.org/torvalds/p/v${KV%-coreos}/v${OKV} -> patch-${KV%-coreos}.patch ${KERNEL_BASE_URI}/linux-${OKV}.tar.xz"
	PATCH_DIR="${FILESDIR}/${KV_MAJOR}.${KV_PATCH}"
else
	SRC_URI="${KERNEL_URI}"
	PATCH_DIR="${FILESDIR}/${KV_MAJOR}.${KV_MINOR}"
fi

# make modules_prepare depends on pahole
RDEPEND="dev-util/pahole"

KEYWORDS="amd64 arm64"
IUSE=""

# XXX: Note we must prefix the patch filenames with "z" to ensure they are
# applied _after_ a potential patch-${KV}.patch file, present when building a
# patchlevel revision.  We mustn't apply our patches first, it fails when the
# local patches overlap with the upstream patch.
UNIPATCH_LIST="
	${PATCH_DIR}/z0001-kbuild-derive-relative-path-for-srctree-from-CURDIR.patch \
	${PATCH_DIR}/z0002-revert-pahole-flags.patch \
	${PATCH_DIR}/z0003-Revert-x86-efistub-Use-1-1-file-memory-mapping-for-P.patch \
	${PATCH_DIR}/z0004-Revert-x86-boot-Increase-section-and-file-alignment-.patch \
	${PATCH_DIR}/z0005-Revert-x86-boot-Split-off-PE-COFF-.data-section.patch \
	${PATCH_DIR}/z0006-Revert-x86-boot-Drop-PE-COFF-.reloc-section.patch \
	${PATCH_DIR}/z0007-Revert-x86-boot-Construct-PE-COFF-.text-section-from.patch \
	${PATCH_DIR}/z0008-Revert-x86-boot-Derive-file-size-from-_edata-symbol.patch \
	${PATCH_DIR}/z0009-Revert-x86-boot-Define-setup-size-in-linker-script.patch \
	${PATCH_DIR}/z0010-Revert-x86-boot-Set-EFI-handover-offset-directly-in-.patch \
	${PATCH_DIR}/z0011-Revert-x86-boot-Grab-kernel_info-offset-from-zoffset.patch \
	${PATCH_DIR}/z0012-Revert-x86-boot-Drop-redundant-code-setting-the-root.patch \
"

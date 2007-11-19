From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Nov 19 16:24:13 2007
Subject: [Ocfs2-devel] Ocfs2-tools 1.3.9 Released, Ocfs2 New Features FAQ
Message-ID: <20071120002232.GW28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The Ocfs2 team has been adding new features to the Ocfs2 file system in the
mainline Linux kernel at a very steady pace for some time now. Most features
are simply available by running the new kernels. Some features however,
require that certain flags and disk structures be updated before the feature
can be used. Other than development versions downloaded via source control,
ocfs2-tools has always created file systems with a set of features geared
towards the Ocfs2 1.2.x release. Ocfs2-tools 1.3.9 is intended to fill that
gap by allowing access to the latest disk features added in the file system.


New versions of Ocfs2-tools are always backwards compatible with old
versions of the kernel module. Also, all newer versions of the Ocfs2 module
will be fully disk compatible with all old versions of the file system.
However, if you are running ocfs2-1.2 on an Enterprise distro kernel you
should stick to Ocfs2-tools 1.2.x for now as the main tools change is
support for new kernel features only available on mainline for now.
Regardless, feel free to read on or review the FAQ to get an idea of what
Ocfs2 1.4 *might* look like. Please note that I stress "might" - the "New
Features FAQ" elaborates: "The final list of features which will be
available to Oracle customers is still to be decided, though obviously we
hope to include as much of this as possible."


Anyone running a mainline kernel or a distro which closely tracks mainline
kernels should consider upgrading as Ocfs2-tools 1.3.9 has support for
several features which are available with more recent kernels.


A source tarball can be downloaded from:

http://oss.oracle.com/projects/ocfs2-tools/dist/files/source/v1.3/ocfs2-tools-1.3.9.tar.gz

Fedora 7 RPMS are available at:

http://oss.oracle.com/projects/ocfs2-tools/files/unofficial/fc7/

The Ubuntu, Debian and OpenSuse package maintainers have been notified of
the new release, so hopefully those packages should show up soon too.


The "New Features FAQ" lists major new Ocfs2 features, and which kernels are
required for them:

http://oss.oracle.com/projects/ocfs2/dist/documentation/ocfs2-new-features.html

The FAQ also has instructions on how to create or upgrade file systems with
new disk features.


If you're one of those people who doesn't like to be bothered with an FAQ
and wants to jump right in, I've got you covered - from the FAQ:

To build an Ocfs2 file system with disk features understood by most recent
kernels:
     $ mkfs.ocfs2 --fs-feature-level=default <device>

To build an Ocfs2 file system with disk features understood on all kernels
and all versions of Ocfs2 ever released:
     $ mkfs.ocfs2 --fs-feature-level=max-compat <device>

To build an Ocfs2 file system with disk features which will work on only the
latest kernel releases:
     $ mkfs.ocfs2 --fs-feature-level=max-features <device>

To turn on sparse files and unwritten extents support:
     $ tunefs.ocfs2 --fs-features=sparse,unwritten <device>


As always, comments and (constructive) criticism are welcome.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com

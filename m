From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Tue, 24 Jun 2008 15:20:04 +0200
Subject: [Ocfs2-devel] [PATCH 0/2]v2 configfs: symlink() fixes
In-Reply-To: <20080623222043.GG592@mail.oracle.com>
References: <1214223378-14203-1-git-send-email-louis.rilling@kerlabs.com>
	<20080623222043.GG592@mail.oracle.com>
Message-ID: <20080624132004.GF7621@hawkmoon.kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Jun 23, 2008 at 03:20:44PM -0700, Joel Becker wrote:
> On Mon, Jun 23, 2008 at 02:16:16PM +0200, Louis Rilling wrote:
> > The following patchset fixes incorrect symlinks to dead items in configfs, which
> > are forbidden by specification.
> > 
> > The first patch actually prevents such dangling symlinks from being created, but
> > introduces a weird(?) behavior where a failing symlink() can make a racing
> > rmdir() fail in the symlink's parent and in the symlink's target as well. This
> > behavior is fixed with the next patch.
> 
> 	Silly question: you've tested this, right?

Yup. I tested this on Linux 2.6.26-rc5 with a modified example_configfs.c
(attached), and on a backport for 2.6.20 with my own subsystem (based on
Kerrighed http://www.kerrighed.org/wiki/index.php/SchedConfig ).

Do you have some regression tests?

sample tests for symlinks:

mkdir -p /config/03-group-children/c1/c1.1
cd /config/03-group-children/c1/c1.1

# repeatedly create and remove a symlink to self
ln -s . link
rm link
ln -s . link
rm link

mkdir /config/02-simple-children/c2

# repeatedly create and remove a symlink to another item
ln -s /config/02-simple-children/c2 link
rm link
ln -s /config/02-simple-children/c2 link
rm link

# create two links with inverted source and target
ln -s /config/02-simple-children/c2 link
ln -s . /config/02-simple-children/c2/link
rm link
rm /config/02-simple-children/c2/link

# try hard to create a link to a removed item
# last loop is to be run in a separate shell
cd /config/03-group-children/c1
while true; do mkdir c1.1 && echo mkdir ok; rmdir c1.1 && echo rmdir ok; done
# in a separate shell
cd /config/02-simple-children/c2
while true; do ln -s /config/03-group-children/c1/c1.1 link && echo ln ok && \
(ls link/ || (echo failed!!!; read foo)) && rm link; done

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: configfs_example.c
Type: text/x-csrc
Size: 12773 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080624/ff54b89d/attachment-0002.bin 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080624/ff54b89d/attachment-0003.bin 

From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Fri Feb  6 12:49:16 2004
Subject: [Ocfs2-devel] important: ocfs2 version number bump
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A568A6@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Okay maybe I'm doing something wrong.

But I just compiled up the latest code for ocfs2 and ocfs-tools.

I did the:

tuneocfs -c 2 /dev/sda1

When I try to mount my filesystem it now just hangs :(

Anyone else seeing this?  The previous revision of the code was working
for mounting and unmounting.

I don't see any messages in my /var/log/messages.

This is a Fedora Core 1 UniProcessor system with all the updates
applied.

John

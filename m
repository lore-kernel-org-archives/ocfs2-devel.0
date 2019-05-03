From: Daniel Sobe <daniel.sobe@nxp.com>
Date: Fri, 3 May 2019 12:54:29 +0000
Subject: [Ocfs2-devel] OCFS2 with global heartbeat on DRBD devices
Message-ID: <AM6PR04MB560573CC0D019D8DE3B14061ED350@AM6PR04MB5605.eurprd04.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I'm wondering why the current version of the "o2cb" tool does not support global heartbeat on DRBD devices.

Do I misunderstand the feature "global heartbeat" in that I should not use it on DRBD at all?

I patched the "o2cb" tool to recognize DRBD devices for starting a global heartbeat. Now the global heartbeat configuration with DRBD seems to work at cluster start, but I wonder whether it really is that easy - or I am just missing something. Maybe it failed silently and I did not notice?

BTW I edited file "o2cb_scandisk.c" function "add_to_list()" like this:

                                               if (!add)
                                                               add = !strncmp(path->path, "/dev/rbd", 8);
                                               if (!add) // added
                                                               add = !strncmp(path->path, "/dev/drbd", 9); // added

and by observing the output of "/proc/drbd" I can tell that the stats for data read and data written on the DRBD device for the global heartbeat increases, while it stays the same on all other DRBD devices. (I have not mounted any of these volumes)

To me it looks like it works. Can anybody comment? Can I somehow "observe" the proper operation of the global heartbeat?

Regards,

Daniel

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20190503/9493557a/attachment.html 

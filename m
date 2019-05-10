From: Daniel Sobe <daniel.sobe@nxp.com>
Date: Fri, 10 May 2019 10:51:01 +0000
Subject: [Ocfs2-devel] [EXT] Re: OCFS2 with global heartbeat on DRBD
 devices
In-Reply-To: <CAOXq0b-kqCfk=9UhyWKL5G+L9j_B4KnV1YwhFZ9dp7Zv9ogtXA@mail.gmail.com>
References: <AM6PR04MB560573CC0D019D8DE3B14061ED350@AM6PR04MB5605.eurprd04.prod.outlook.com>
	<CAOXq0b-kqCfk=9UhyWKL5G+L9j_B4KnV1YwhFZ9dp7Zv9ogtXA@mail.gmail.com>
Message-ID: <AM6PR04MB560500C81C599AF4183ABB98ED0C0@AM6PR04MB5605.eurprd04.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Roger,

I?m running 2 servers on which users can log in and do their work. Both servers have storage directly attached, so I use DRBD and OCFS2 on top. Users see the content of their home directory, no matter which server they log in. Each user home is a different DRBD (and thus OCFS2) LVM volume.

My gut feeling is that the default local heartbeat for every OCFS2 volume is a bad idea when the number of volumes in a cluster increases. Thus I wanted to use a global heartbeat on just one DRBD volume, once the stability issue that started somewhere in the 4.x kernel series has been resolved (it already looks like it is).

I was surprised, however, that DRBD volumes are disregarded when setting up a global heartbeat. Although I could add this to the tools myself easily and find it ?working? somehow, I was wondering whether it wasn?t a bad idea to do that, if this simple change hasn?t found its way into the tools yet. I might not have understood the idea behind the heartbeat, which I believe is a way for each node to announce its presence to the cluster, and to understand the status of all other nodes. If that was the case, it would not sound reasonable to repeat this information for every volume that is part of that cluster ? or at least not for volumes on the same storage device, which is the case in my setup.

I?d be glad if you can help me understand whether I described this correctly or not.

Regards,

Daniel

From: Roger Zhou_Zhiqiang <zzhou@suse.com>
Sent: Freitag, 10. Mai 2019 07:02
To: Daniel Sobe <daniel.sobe@nxp.com>
Cc: ocfs2-devel at oss.oracle.com
Subject: [EXT] Re: [Ocfs2-devel] OCFS2 with global heartbeat on DRBD devices


Caution: EXT Email
How you use DRBD could be critical information to shed the light about the problem you are facing? And, the broader picture about your use case is useful too, if you can share?

You may have to setup DRBD in dual-primary mode to be the shared device for Global Heartbeat.

DRBD can be a beast if you not use it well, though it can be a good combination for drbd + ocfs2, eg. a report for 10 years [1]

And, because of DRBD tightly integrated with pacemaker, you may consider `cluster_stack=pcmk` for OCFS2 instead of o2cb.

[1] https://oss.oracle.com/pipermail/ocfs2-users/2016-March/006383.html<https://urldefense.proofpoint.com/v2/url?u=https-3A__eur01.safelinks.protection.outlook.com_-3Furl-3Dhttps-253A-252F-252Foss.oracle.com-252Fpipermail-252Focfs2-2Dusers-252F2016-2DMarch-252F006383.html-26data-3D02-257C01-257Cdaniel.sobe-2540nxp.com-257C31c7d1906191456e90c208d6d504ba55-257C686ea1d3bc2b4c6fa92cd99c5c301635-257C0-257C1-257C636930613636285916-26sdata-3DNGoCJRhlkS89ZWqXfGAZVuAkZO-252BlQylWu02QrAptWnI-253D-26reserved-3D0&d=DwIGaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Y3SG7jYwMzbtcVVwE7M8EcpDxUwpsOqCnaRDFPAqVEs&s=U9BTs-Gn8D85rdVsNehkv3D32Y4l2clCzJxNLb0kMZA&e=>


On Fri, 3 May 2019 at 12:55, Daniel Sobe <daniel.sobe at nxp.com<mailto:daniel.sobe@nxp.com>> wrote:
Hi,

I?m wondering why the current version of the ?o2cb? tool does not support global heartbeat on DRBD devices.

Do I misunderstand the feature ?global heartbeat? in that I should not use it on DRBD at all?

I patched the ?o2cb? tool to recognize DRBD devices for starting a global heartbeat. Now the global heartbeat configuration with DRBD seems to work at cluster start, but I wonder whether it really is that easy ? or I am just missing something. Maybe it failed silently and I did not notice?

BTW I edited file ?o2cb_scandisk.c? function ?add_to_list()? like this:

                                               if (!add)
                                                               add = !strncmp(path->path, "/dev/rbd", 8);
                                               if (!add) // added
                                                               add = !strncmp(path->path, "/dev/drbd", 9); // added

and by observing the output of ?/proc/drbd? I can tell that the stats for data read and data written on the DRBD device for the global heartbeat increases, while it stays the same on all other DRBD devices. (I have not mounted any of these volumes)

To me it looks like it works. Can anybody comment? Can I somehow ?observe? the proper operation of the global heartbeat?

Regards,

Daniel

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com<mailto:Ocfs2-devel@oss.oracle.com>
https://oss.oracle.com/mailman/listinfo/ocfs2-devel<https://urldefense.proofpoint.com/v2/url?u=https-3A__eur01.safelinks.protection.outlook.com_-3Furl-3Dhttps-253A-252F-252Foss.oracle.com-252Fmailman-252Flistinfo-252Focfs2-2Ddevel-26data-3D02-257C01-257Cdaniel.sobe-2540nxp.com-257C31c7d1906191456e90c208d6d504ba55-257C686ea1d3bc2b4c6fa92cd99c5c301635-257C0-257C1-257C636930613636285916-26sdata-3DuVMdmp7NMrfFso1DS9Tz0YC2-252BOkbjHTn8RX7JH7aj8k-253D-26reserved-3D0&d=DwIGaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Y3SG7jYwMzbtcVVwE7M8EcpDxUwpsOqCnaRDFPAqVEs&s=1R6nbgMutHUhGxC7m3tH61giWmi93f3PFZp1mhOFblY&e=>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20190510/49d27175/attachment.html 

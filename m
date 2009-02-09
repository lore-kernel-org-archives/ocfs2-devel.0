From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 09 Feb 2009 12:22:34 -0800
Subject: [Ocfs2-devel] Problema to Mount drbd0
In-Reply-To: <9112ced60902091215u1ede078eo17eb0773d2bb1594@mail.gmail.com>
References: <9112ced60902091215u1ede078eo17eb0773d2bb1594@mail.gmail.com>
Message-ID: <4990908A.1020507@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Upgrade to ocfs2 1.4. AFAIR this issue has been fixed.

Rafael Emerick wrote:
> Hi!
>
> I found a similar problem in an user maillist about my problem, but 
> didnt work here.
>
> Im using a CentOS 5.2, with a Xen 2.6.18 kernel and a compiled Drbd 8.
>
> So, a load a ocfs2 module and use the mkfs.ocfs2 successfully with 
> /dev/drbd0
> But, when i try to mount it a take this log:
>
> # mount.ocfs2 /dev/drbd0 /mnt
> mount.ocfs2: I/O error on channel while trying to join the group
>
> # tail /var/log/messages
> Feb  9 18:11:08 tundra kernel: (31249,0):o2hb_setup_one_bio:290 ERROR: 
> Error adding page to bio i = 7, vec_len = 4096, len = 0
> Feb  9 18:11:08 tundra kernel: , start = 0
> Feb  9 18:11:08 tundra kernel: (31249,0):o2hb_read_slots:385 ERROR: 
> status = -5
> Feb  9 18:11:08 tundra kernel: (31249,0):o2hb_populate_slot_data:1299 
> ERROR: status = -5
> Feb  9 18:11:08 tundra kernel: (31249,0):o2hb_region_dev_write:1399 
> ERROR: status = -5
> Feb  9 18:11:42 tundra kernel: (31259,0):o2hb_setup_one_bio:290 ERROR: 
> Error adding page to bio i = 7, vec_len = 4096, len = 0
> Feb  9 18:11:42 tundra kernel: , start = 0
> Feb  9 18:11:42 tundra kernel: (31259,0):o2hb_read_slots:385 ERROR: 
> status = -5
> Feb  9 18:11:42 tundra kernel: (31259,0):o2hb_populate_slot_data:1299 
> ERROR: status = -5
> Feb  9 18:11:42 tundra kernel: (31259,0):o2hb_region_dev_write:1399 
> ERROR: status = -5
>
> The o2cb loaded successfully, but whet i run /etc/init.d/ocfs2 
> start/status i do not have an answer
>
> Can you help me?
> thank you for your attention
>
> Rgs
>
>
> -- 
> Rafael Emerick Z. de Oliveira
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

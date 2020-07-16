From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 16 Jul 2020 08:55:48 -0700
Subject: [Ocfs2-devel] missing patch in recent kernels?
In-Reply-To: <alpine.LSU.2.21.2007161726340.21202@er-systems.de>
References: <alpine.LSU.2.21.2007161726340.21202@er-systems.de>
Message-ID: <827a3bc7-fbb7-6b8f-816f-2f8174d11456@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's in mm and linux-next, i think it will be soon merged by Andrew.

Thanks,

Junxiao.

On 7/16/20 8:32 AM, Thomas Voegtle wrote:
>
> Hello,
>
>
> I see the same Oops on my system as in:
> https://oss.oracle.com/pipermail/ocfs2-devel/2020-July/015232.html
>
> I used v4.9.230 which included (in 4.9.229):
> ocfs2-fix-panic-on-nfs-server-over-ocfs2.patch
> ocfs2-fix-value-of-ocfs2_invalid_slot.patch
> ocfs2-load-global_inode_alloc.patch
>
> Isn't then that patch named "ocfs2: change slot number type s16 to
> u16" missing mentioned in that mail thread?
>
> I even don't find it in the main linux branch?
>
>
> ?? Thomas
>
>
>
>
>

From: Greg KH <gregkh@linuxfoundation.org>
Date: Sat, 3 Nov 2018 07:44:57 +0100
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: free up write context when
	direct IO failed
In-Reply-To: <20181102170632.25921-1-wen.gang.wang@oracle.com>
References: <20181102170632.25921-1-wen.gang.wang@oracle.com>
Message-ID: <20181103064457.GC1517@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, stable@vger.kernel.org, gechangwei@live.cn, junxiao.bi@oracle.com, akpm@linux-foundation.org, jiangqi903@gmail.com

On Fri, Nov 02, 2018 at 10:06:32AM -0700, Wengang Wang wrote:
> The write context should also be freed even when direct IO failed.
> Otherwise a memory leak is introduced and entries remain in
> oi->ip_unwritten_list causing the following BUG later in unlink path:
> 
> ERROR: bug expression: !list_empty(&oi->ip_unwritten_list)
> ERROR: Clear inode of 215043, inode has unwritten extents
> ...
> Call Trace:
> ? __set_current_blocked+0x42/0x68
> ocfs2_evict_inode+0x91/0x6a0 [ocfs2]
> ? bit_waitqueue+0x40/0x33
> evict+0xdb/0x1af
> iput+0x1a2/0x1f7
> do_unlinkat+0x194/0x28f
> SyS_unlinkat+0x1b/0x2f
> do_syscall_64+0x79/0x1ae
> entry_SYSCALL_64_after_hwframe+0x151/0x0
> 
> This patch also logs, with frequency limit, direct IO failures.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
> v1 -> v2: log direct IO failures
> ---
>  fs/ocfs2/aops.c            | 12 ++++++++++--
>  fs/ocfs2/cluster/masklog.h |  9 +++++++++
>  2 files changed, 19 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://urldefense.proofpoint.com/v2/url?u=https-3A__www.kernel.org_doc_html_latest_process_stable-2Dkernel-2Drules.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=P2I-XIsUfJ0h1jlymjMe7ziTkrs4pJ-sCZYaijMZpWw&s=ygRPYcgBDv1LNZjnBgPzukjEYvJ_sE8jlBo7R_3_b5c&e=
for how to do this properly.

</formletter>

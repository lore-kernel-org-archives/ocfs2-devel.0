From: Greg KH <gregkh@linuxfoundation.org>
Date: Sun, 27 May 2018 07:42:44 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a misuse a of brelse after
 failing ocfs2_check_dir_entry
In-Reply-To: <HK2PR06MB04522E81177A3E01EF47A828D56F0@HK2PR06MB0452.apcprd06.prod.outlook.com>
References: <HK2PR06MB04522E81177A3E01EF47A828D56F0@HK2PR06MB0452.apcprd06.prod.outlook.com>
Message-ID: <20180527054244.GB29427@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Changwei Ge <gechangwei@live.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "mark@fasheh.com" <mark@fasheh.com>, "jiangqi903@gmail.com" <jiangqi903@gmail.com>, "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>, Changwei Ge <ge.changwei@h3c.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>

On Sun, May 27, 2018 at 03:16:52AM +0000, Changwei Ge wrote:
> From: Changwei Ge <ge.changwei@h3c.com>
> 
> Somehow, file system metadata was corrupted, which causes
> ocfs2_check_dir_entry() to fail in function ocfs2_dir_foreach_blk_el().
> 
> According to the original design intention, if above happens we should
> skip the problematic block and continue to retrieve dir entry. But there
> is obviouse misuse of brelse around related code.
> 
> After failure of ocfs2_check_dir_entry(), currunt code just moves to next
> position and uses the problematic buffer head again and again during
> which the problematic buffer head is released for multiple times. I
> suppose, this a serious issue which is long-lived in ocfs2. This may
> cause other file systems which is also used in a the same host insane.
> 
> So we should also consider about bakcporting this patch into
> linux -stable.
> 
> Suggested-by: Changkuo Shi <shi.changkuo@h3c.com>
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
> ---
>  fs/ocfs2/dir.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://urldefense.proofpoint.com/v2/url?u=https-3A__www.kernel.org_doc_html_latest_process_stable-2Dkernel-2Drules.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=ZFGNdxMGJOFwcOvw1WPDqEeWXHqRt00lPWocekbXDwg&s=bqQ638ETryFkKttOq4dXSro7DV0OgJy7WTajPiK6fxw&e=
for how to do this properly.

</formletter>

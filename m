From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Oct 2008 02:30:26 -0700
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: add array bounds checking
In-Reply-To: <1224750884-10976-1-git-send-email-tiger.yang@oracle.com>
References: <49003524.3090405@oracle.com>
	<1224750884-10976-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20081023093026.GG1580@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 23, 2008 at 04:34:44PM +0800, Tiger Yang wrote:
> This could avoid arry bounds exceeded issue.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/xattr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 754e5fa..888641d 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -164,7 +164,7 @@ static inline const char *ocfs2_xattr_prefix(int name_index)
>  {
>  	struct xattr_handler *handler = NULL;
>  
> -	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
> +	if (name_index > 0 && name_index < ARRAY_SIZE(ocfs2_xattr_handler_map))
>  		handler = ocfs2_xattr_handler_map[name_index];

	Another option is to define the map as:

static struct xattr_handler *ocfs2_xattr_handler_map[OCFS2_ATTR_MAX] = {

This reuses our nice OCFS2_XATTR_MAX value.  But both methods work.

Joel

-- 

"You cannot bring about prosperity by discouraging thrift. You cannot
 strengthen the weak by weakening the strong. You cannot help the wage
 earner by pulling down the wage payer. You cannot further the
 brotherhood of man by encouraging class hatred. You cannot help the
 poor by destroying the rich. You cannot build character and courage by
 taking away a man's initiative and independence. You cannot help men
 permanently by doing for them what they could and should do for
 themselves."
	- Abraham Lincoln 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

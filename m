From: Kees Cook <keescook@chromium.org>
Date: Fri, 29 May 2020 01:23:19 -0700
Subject: [Ocfs2-devel] [PATCH 06/13] ocfs2: use new sysctl subdir helper
 register_sysctl_subdir()
In-Reply-To: <20200529074108.16928-7-mcgrof@kernel.org>
References: <20200529074108.16928-1-mcgrof@kernel.org>
	<20200529074108.16928-7-mcgrof@kernel.org>
Message-ID: <202005290121.C78B4AC@keescook>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: jack@suse.cz, rafael@kernel.org, airlied@linux.ie, amir73il@gmail.com, clemens@ladisch.de, dri-devel@lists.freedesktop.org, joseph.qi@linux.alibaba.com, sfr@canb.auug.org.au, mark@fasheh.com, rdna@fb.com, yzaikin@google.com, arnd@arndb.de, intel-gfx@lists.freedesktop.org, julia.lawall@lip6.fr, jlbec@evilplan.org, rodrigo.vivi@intel.com, nixiaoming@huawei.com, vbabka@suse.cz, axboe@kernel.dk, tytso@mit.edu, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Fri, May 29, 2020 at 07:41:01AM +0000, Luis Chamberlain wrote:
> This simplifies the code considerably. The following coccinelle
> SmPL grammar rule was used to transform this code.
> 
> // pycocci sysctl-subdir.cocci fs/ocfs2/stackglue.c
> 
> @c1@
> expression E1;
> identifier subdir, sysctls;
> @@
> 
> static struct ctl_table subdir[] = {
> 	{
> 		.procname = E1,
> 		.maxlen = 0,
> 		.mode = 0555,
> 		.child = sysctls,
> 	},
> 	{ }
> };
> 
> @c2@
> identifier c1.subdir;
> 
> expression E2;
> identifier base;
> @@
> 
> static struct ctl_table base[] = {
> 	{
> 		.procname = E2,
> 		.maxlen = 0,
> 		.mode = 0555,
> 		.child = subdir,
> 	},
> 	{ }
> };
> 
> @c3@
> identifier c2.base;
> identifier header;
> @@
> 
> header = register_sysctl_table(base);
> 
> @r1 depends on c1 && c2 && c3@
> expression c1.E1;
> identifier c1.subdir, c1.sysctls;
> @@
> 
> -static struct ctl_table subdir[] = {
> -	{
> -		.procname = E1,
> -		.maxlen = 0,
> -		.mode = 0555,
> -		.child = sysctls,
> -	},
> -	{ }
> -};
> 
> @r2 depends on c1 && c2 && c3@
> identifier c1.subdir;
> 
> expression c2.E2;
> identifier c2.base;
> @@
> -static struct ctl_table base[] = {
> -	{
> -		.procname = E2,
> -		.maxlen = 0,
> -		.mode = 0555,
> -		.child = subdir,
> -	},
> -	{ }
> -};
> 
> @r3 depends on c1 && c2 && c3@
> expression c1.E1;
> identifier c1.sysctls;
> expression c2.E2;
> identifier c2.base;
> identifier c3.header;
> @@
> 
> header =
> -register_sysctl_table(base);
> +register_sysctl_subdir(E2, E1, sysctls);
> 
> Generated-by: Coccinelle SmPL
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  fs/ocfs2/stackglue.c | 27 ++++-----------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index a191094694c6..addafced7f59 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -677,28 +677,8 @@ static struct ctl_table ocfs2_mod_table[] = {
>  	},
>  	{ }
>  };
> -
> -static struct ctl_table ocfs2_kern_table[] = {
> -	{
> -		.procname	= "ocfs2",
> -		.data		= NULL,
> -		.maxlen		= 0,
> -		.mode		= 0555,
> -		.child		= ocfs2_mod_table
> -	},
> -	{ }
> -};
> -
> -static struct ctl_table ocfs2_root_table[] = {
> -	{
> -		.procname	= "fs",
> -		.data		= NULL,
> -		.maxlen		= 0,
> -		.mode		= 0555,
> -		.child		= ocfs2_kern_table
> -	},
> -	{ }
> -};
> +	.data		= NULL,
> +	.data		= NULL,

The conversion script doesn't like the .data field assignments. ;)

Was this series built with allmodconfig? I would have expected this to
blow up very badly. :)

-- 
Kees Cook

From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 14 May 2014 10:51:14 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove some redundant casting
In-Reply-To: <20140509224508.27912.qmail@ns.horizon.com>
References: <20140509224508.27912.qmail@ns.horizon.com>
Message-ID: <5372DA22.90805@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao's Oracle email address was obsolete.

On 05/10/2014 06:45 AM, George Spelvin wrote:
> There are two standard techniques for dereferencing structures pointed
> to by void *: cast to the right type each time they're used, or assign
> to local variables of the right type.
> 
> But there's no need to do *both*.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
> Obviously, this makes zero difference to the generated code, but
> it's prettier.

Indeed :), the patch looks good to me.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>


Thanks,
-Jeff

From: Lars Marowsky-Bree <lmb@suse.com>
Date: Thu, 28 Nov 2013 09:17:25 -0000
Subject: [Ocfs2-devel] [PATCH] Remove versioning information
In-Reply-To: <20131126233722.GA20032@shrek.lan>
References: <20131126233722.GA20032@shrek.lan>
Message-ID: <20131128091720.GQ22733@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013-11-26T17:37:27, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

> The versioning information is confusing for end-users. The numbers
> are stuck at 1.5.0 while the tools version have moved to 1.8.2.
> 
> I suggest removing the versioning system in the ocfs2 module and let
> the kernel version be the guide to debug issues. However, if
> you think versioning is still required, please state the reason and
> modify the version string in the *ver.h files.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Reviewed-by: Lars Marowsky-Bree <lmb@suse.com>

I agree, this is confusing for our users/customers and not quite
appropriate for an in-kernel maintained module.


Regards,
    Lars

-- 
Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend?rffer, HRB 21284 (AG N?rnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

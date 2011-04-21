From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 21 Apr 2011 14:51:57 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Skip mount recovery for
	hard-ro mounts
In-Reply-To: <1303345494-15425-1-git-send-email-sunil.mushran@oracle.com>
References: <1303345494-15425-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110421215157.GN13325@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 20, 2011 at 05:24:54PM -0700, Sunil Mushran wrote:
> Patch skips mount recovery for hard-ro mounts which otherwise leads to an oops.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
I understand there's a couple more places we need to fix up which have a
similar bug. Still, this seems a good fix to start with.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh

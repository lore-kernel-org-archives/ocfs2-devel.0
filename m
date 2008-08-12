From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 12 Aug 2008 14:22:15 -0700
Subject: [Ocfs2-devel] [PATCH 11/15] Add xattr bucket iteration for
	large numbers of EAs.v11
In-Reply-To: <1218061894-7693-9-git-send-email-tao.ma@oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-9-git-send-email-tao.ma@oracle.com>
Message-ID: <20080812212215.GI21187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 07, 2008 at 06:31:31AM +0800, Tao Ma wrote:
> Modification from V2 to V3:
> 1. Add a new abstration of ocfs2_xattr_bucket which records bhs
>    in this bucket and ocfs2_xattr_header for quick refrence.
> 2. Now ocfs2_iterate_xattr_buckets will only read the bhs of the
>    bucket, creat a ocfs2_xattr_bucket and let the caller do all
>    the rest of the work.
> 3. According to the discussion with Mark, now all the xe_entry
>    will only exist in the 1st block of the bucket and name/value
>    pair will not spread multiple blocks, so the efficiency will
>    be improved and the code is much easier.

Great, I like this new abstraction too.
	--Mark

--
Mark Fasheh

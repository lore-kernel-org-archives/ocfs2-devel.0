From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 24 Feb 2014 14:28:50 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix quota file corruption
In-Reply-To: <1392896399-25059-1-git-send-email-jack@suse.cz>
References: <1392896399-25059-1-git-send-email-jack@suse.cz>
Message-ID: <20140224222850.GE5716@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 20, 2014 at 12:39:59PM +0100, Jan Kara wrote:
> Global quota files are accessed from different nodes. Thus we cannot
> cache offset of quota structure in the quota file after we drop our
> node reference count to it because after that moment quota structure may
> be freed and reallocated elsewhere by a different node resulting in
> corruption of quota file.
> 
> Fix the problem by clearing dq_off when we are releasing dquot
> structure. We also remove the DB_READ_B handling because it is useless -
> DQ_ACTIVE_B is set iff DQ_READ_B is set.
> 
> CC: stable at vger.kernel.org
> CC: Goldwyn Rodrigues <rgoldwyn@suse.de>
> CC: Mark Fasheh <mfasheh@suse.de>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks Jan, this looks good.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 7 Apr 2009 09:32:58 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Reserve 1 more cluster in
	expanding_inline_dir for indexed dir.
In-Reply-To: <1239061257-27065-1-git-send-email-tao.ma@oracle.com>
References: <1239061257-27065-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090407163258.GU14571@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 07, 2009 at 07:40:57AM +0800, Tao Ma wrote:
> In ocfs2_expand_inline_dir, we calculate whether we need 1 extra
> cluster if we can't store the dx inline the root and save it in
> dx_alloc. So add it when we call ocfs2_reserve_clusters.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

Good catch Tao, thanks!
	--Mark

--
Mark Fasheh

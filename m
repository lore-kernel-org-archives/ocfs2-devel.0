From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 16 Jul 2008 17:30:22 -0700
Subject: [Ocfs2-devel] [PATCH 05/15] Add xattr header in ocfs2.v2
In-Reply-To: <20080627070110.GA20347@tma-pc2.cn.oracle.com>
References: <48648B3E.6050808@oracle.com>
	<20080627070110.GA20347@tma-pc2.cn.oracle.com>
Message-ID: <20080717003022.GG28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 27, 2008 at 03:01:10PM +0800, Tao Ma wrote:
> Modification from V1 to V2:
> Add EA disk layout to ocfs2_fs.h.

By the way - I just realized that none of these structures have per-field
annotations. We absolutely need those.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Mar 2009 09:48:00 -0700
Subject: [Ocfs2-devel] [PATCH] OCFS2: Pagecache usage optimization on
	OCFS2
In-Reply-To: <6.0.0.20.2.20090316155231.070bd0f8@172.19.0.2>
References: <6.0.0.20.2.20090316155231.070bd0f8@172.19.0.2>
Message-ID: <20090317164800.GN17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 17, 2009 at 01:08:22PM +0900, Hisashi Hifumi wrote:
> I introduced "is_partially_uptodate" aops for OCFS2.

Yep, this patch is in ocfs2.git, and I'll be sending it upstream during the
next merge window. Thanks for an impressive optimization!
	--Mark

--
Mark Fasheh

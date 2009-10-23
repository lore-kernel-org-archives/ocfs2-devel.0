From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 23 Oct 2009 11:00:34 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag
	FIEMAP_EXTENT_SHARED
In-Reply-To: <1256173509-2831-2-git-send-email-sunil.mushran@oracle.com>
References: <1256173509-2831-1-git-send-email-sunil.mushran@oracle.com>
	<1256173509-2831-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091023180034.GA11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 06:05:08PM -0700, Sunil Mushran wrote:
> Patch adds flag FIEMAP_EXTENT_SHARED to denote extents that are
> shared with other inodes.

This looks pretty sane to me. Thanks Sunil.


> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh

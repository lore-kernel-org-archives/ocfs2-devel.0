From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 3 Nov 2008 16:20:37 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: add search result checking in
	block_get
In-Reply-To: <1225623861-6394-1-git-send-email-tiger.yang@oracle.com>
References: <1225623861-6394-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20081104002037.GQ15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Nov 02, 2008 at 07:04:21PM +0800, Tiger Yang wrote:
> Because ocfs2_xattr_block_find may return zero when not found
> the xattr entry, and struct ocfs2_xattr_search may have not
> be initialized. So check the search result is necessary to
> avoid access NULL pointer.

Ok, thanks. This is now in the fixes branch.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 6 Nov 2008 17:17:06 -0800
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: add security xattr API
In-Reply-To: <1225366854-6357-1-git-send-email-tiger.yang@oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225366854-6357-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20081107011706.GH15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 30, 2008 at 07:40:54PM +0800, Tiger Yang wrote:
> This patch add security xattr set/get/list APIs to
> support security xattr in ocfs2.

This patch looks great! One question - should we be setting security
attributes on symlinks too?
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 6 Nov 2008 17:03:23 -0800
Subject: [Ocfs2-devel] [PATCH 07/15] ocfs2: add ocfs2_xattr_set_handle
In-Reply-To: <1225366838-6338-1-git-send-email-tiger.yang@oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225366838-6338-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20081107010323.GG15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 30, 2008 at 07:40:38PM +0800, Tiger Yang wrote:
> This function use to set xattr in a started transaction.
> It is similar to ocfs2_xattr_set.

This looks good. Glad to see so much code re-use.
	--Mark

--
Mark Fasheh

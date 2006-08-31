From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Aug 31 20:34:48 2006
Subject: [Ocfs2-devel] Re: a patch for ocfs2_link
In-Reply-To: <44F79A94.3040101@oracle.com>
References: <44F79A94.3040101@oracle.com>
Message-ID: <20060901033445.GC8792@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tiger,

On Fri, Sep 01, 2006 at 10:27:32AM +0800, Tiger Yang wrote:
> This patch remove the redundant "i_nlink >= OCFS2_LINK_MAX" check
> and add an unlinked directory check.
Ok, this looks good - thanks.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com

From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Mar 29 08:31:39 2007
Subject: [Ocfs2-devel] Remove the printing of harmless ERRORS like
	ECONNRESET, EPIPE
In-Reply-To: <460B6434.7020401@oracle.com>
References: <460B6434.7020401@oracle.com>
Message-ID: <20070329153135.GH2919@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 29, 2007 at 03:01:08PM +0800, tao.ma wrote:
> Remove the printing of harmless ERRORS like ECONNRESET, EPIPE.
> For more details, see
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=865
> 
> The ocfs2 kernel source code in git tree don't have function
> "ocfs2_file_sendfile", so this bug only exists in ocfs2-1.2 branch.

That looks good - please commit with my sob.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com

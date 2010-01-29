From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 29 Jan 2010 10:14:09 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not downconvert if the lock
	level is already compatible
In-Reply-To: <1264787051-7491-1-git-send-email-sunil.mushran@oracle.com>
References: <1264787051-7491-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100129181409.GV11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 29, 2010 at 09:44:11AM -0800, Sunil Mushran wrote:
> During upconvert, if the master were to send a BAST, dlmglue will detect the
> upconversion in process and send a cancel convert to the master. Upon receiving
> the AST for the cancel convert, it will re-process the lock resource to determine
> whether it needs downconverting. Say, the up was from PR to EX and the BAST was
> for EX. After the cancel convert, it will need to downconvert to NL.
> 
> However, if the node was originally upconverting from NL to EX, then there would
> be no reason to downconvert (assuming the same message sequence).
> 
> This patch makes dlmglue consider the possibility that the current lock level
> is already compatible and that downconverting is not required.
> 
> Joel Becker <joel.becker@oracle.com> assisted in fixing this issue.
> 
> Fixes ossbz#1178
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1178
> 
> Reported-by: Coly Li <coly.li@suse.de>
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Hmm, looks like it's the month of dlmglue fixes?  :)

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh

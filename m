From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 6 May 2010 08:24:02 -0700
Subject: [Ocfs2-devel] [patch] ocfs2: potential ERR_PTR dereference on
	error paths
In-Reply-To: <20100422093929.GK29647@bicker>
References: <20100422093929.GK29647@bicker>
Message-ID: <20100506152402.GH24797@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 22, 2010 at 11:39:29AM +0200, Dan Carpenter wrote:
> If "handle" is non null at the end of the function then we assume it's a
> valid pointer and pass it to ocfs2_commit_trans();
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh

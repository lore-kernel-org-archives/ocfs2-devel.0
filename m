From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 9 Mar 2015 08:02:45 -0700
Subject: [Ocfs2-devel] [patch 1/2] ocfs2: dereferencing freed pointers
 in ocfs2_reflink()
In-Reply-To: <20150305174619.GA13294@mwanda>
References: <20150124193124.GA18322@mwanda>
 <20150305174619.GA13294@mwanda>
Message-ID: <20150309150245.GJ23615@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, kernel-janitors@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Mar 05, 2015 at 08:46:19PM +0300, Dan Carpenter wrote:
> The code at the "out" label assumes that "default_acl" and "acl" are
> NULL, but actually the pointers can be NULL, unitialized, or freed.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh

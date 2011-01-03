From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 03 Jan 2011 09:54:40 -0800
Subject: [Ocfs2-devel] [patch -next] ocfs2/cluster: dereferencing before
 checking in nst_seq_show()
In-Reply-To: <20110103060020.GW1886@bicker>
References: <20110103060020.GW1886@bicker>
Message-ID: <4D220D60.1040703@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/02/2011 10:00 PM, Dan Carpenter wrote:
> In the original code, we dereferenced "nst" before checking that it was
> non-NULL.  I moved the check forward and pulled the code in an indent
> level.
>
> Signed-off-by: Dan Carpenter<error27@gmail.com>

Acked-by: Sunil Mushran<sunil.mushran@oracle.com>

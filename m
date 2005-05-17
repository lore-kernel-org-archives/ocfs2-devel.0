From: Christoph Hellwig <hch@lst.de>
Date: Tue May 17 03:10:38 2005
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] manish commits r2251 -
	trunk/fs/ocfs2
In-Reply-To: <200505170114.j4H1EBTj028369@oss.oracle.com>
References: <200505170114.j4H1EBTj028369@oss.oracle.com>
Message-ID: <20050517081039.GA29015@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 16, 2005 at 08:14:11PM -0500, svn-commits@oss.oracle.com wrote:
> Author: manish
> Signed-off-by: mfasheh
> Date: 2005-05-16 20:14:10 -0500 (Mon, 16 May 2005)
> New Revision: 2251
> 
> Modified:
>    trunk/fs/ocfs2/namei.c
> Log:
> Cosmetic coding style fix


While we're fixing at style issues, could you please remove all the
typedefs for struct types?

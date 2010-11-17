From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Nov 2010 15:24:18 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: lock the page in
	__ocfs2_page_mkwrite()
In-Reply-To: <20101117231732.GD25677@mail.oracle.com>
References: <201011050455.oA52fktp020706@rcsinet15.oracle.com>
	<20101117231732.GD25677@mail.oracle.com>
Message-ID: <4CE46422.8030706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11/17/2010 03:17 PM, Joel Becker wrote:
> On Fri, Nov 05, 2010 at 12:53:16PM +0800, Wengang Wang wrote:
>> Lock the page in __ocfs2_page_mkwrite(). Or we may get -EINVAL error
>> from ocfs2_grab_pages_for_write() if the page(page cache) gets truncated.
> 	Hmm.  Have you seen this happen?  Do you have a reproducible
> test case?  The inode lock and alloc sem are taken in
> ocfs2_page_mkwrite(), which should prevent real truncation of the file
> and truncation of the page due to downconvert.  I think you're saying
> that someone could flush the pagecache and cause a problem here, but I'd
> like to have a testcase.
> 	Also, earlier in __ocfs2_page_mkwrite() we return 0 when the
> mapping is wrong.  Can we do that again?

orabug#10127979

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 24 Nov 2016 17:21:06 +0300
Subject: [Ocfs2-devel] ocfs2: fix sparse file & data ordering issue in
 direct io
In-Reply-To: <c17a6371-aab0-45c6-451b-2aa4e6617d66@oracle.com>
References: <20160309102505.GA15030@mwanda> <20161115103330.GL28558@mwanda>
	<20161115103638.GM28558@mwanda>
	<777b2218-d12e-ea96-7e1c-6852c14b71ec@suse.com>
	<20161116104539.GO28558@mwanda>
	<96764e72-b2ff-f788-0452-bf3f8cb6b268@suse.com>
	<20161117100319.GS28558@mwanda>
	<c17a6371-aab0-45c6-451b-2aa4e6617d66@oracle.com>
Message-ID: <20161124141820.GY28558@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 22, 2016 at 10:29:52AM +0800, Junxiao Bi wrote:
> Hi Dan,
> 
> It will not cause a real issue. -EAGAIN can be only returned in
> __ocfs2_page_mkwrite() path where "locked_page" is NULL, so that
> function will return VM_FAULT_NOPAGE before accessing "fsdata".
> 

Good enough.  Thanks for looking at this.

regards,
dan carpenter

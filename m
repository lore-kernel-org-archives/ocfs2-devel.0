From: Eric Ren <zren@suse.com>
Date: Thu, 17 Nov 2016 11:08:08 +0800
Subject: [Ocfs2-devel] ocfs2: fix sparse file & data ordering issue in
 direct io
In-Reply-To: <20161116104539.GO28558@mwanda>
References: <20160309102505.GA15030@mwanda> <20161115103330.GL28558@mwanda>
	<20161115103638.GM28558@mwanda>
	<777b2218-d12e-ea96-7e1c-6852c14b71ec@suse.com>
	<20161116104539.GO28558@mwanda>
Message-ID: <96764e72-b2ff-f788-0452-bf3f8cb6b268@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 11/16/2016 06:45 PM, Dan Carpenter wrote:
> On Wed, Nov 16, 2016 at 10:33:49AM +0800, Eric Ren wrote:
> That silences the warning, of course, but I feel like the code is buggy.
> How do we know that we don't hit that exit path?
Sorry, I missed your point. Do you mean the below?

"1817 goto out_quota; " will free (*wc), but with "ret = 0". Thus, the caller
think it's OK to use (*wc), but...

Do I understand you correctly?

Eric
>
> fs/ocfs2/aops.c
>    1808          /*
>    1809           * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
>    1810           * the target page. In this case, we exit with no error and no target
>    1811           * page. This will trigger the caller, page_mkwrite(), to re-try
>    1812           * the operation.
>    1813           */
>    1814          if (ret == -EAGAIN) {
>    1815                  BUG_ON(wc->w_target_page);
>    1816                  ret = 0;
>    1817                  goto out_quota;
>    1818          }
>
> regards,
> dan carpenter
>
>
>

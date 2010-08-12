From: Dan Carpenter <error27@gmail.com>
Date: Thu, 12 Aug 2010 09:14:31 +0200
Subject: [Ocfs2-devel] [PATCH 1/2] fs/ocfs2/dlm: Eliminate update
	of	list_for_each_entry loop cursor
In-Reply-To: <Pine.LNX.4.64.1008120735200.16027@ask.diku.dk>
References: <Pine.LNX.4.64.1008071108540.5821@ask.diku.dk>
	<20100812000355.GA7195@mail.oracle.com>
	<Pine.LNX.4.64.1008120735200.16027@ask.diku.dk>
Message-ID: <20100812071431.GF645@bicker>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia@diku.dk>
Cc: Joel Becker <Joel.Becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Sunil Mushran <sunil.mushran@oracle.com>

On Thu, Aug 12, 2010 at 07:46:13AM +0200, Julia Lawall wrote:
> 
> This seems a bit ugly to me, since it exposes the implementation of the 
> list abstraction.  What about the following:
> 
> lock = NULL;
> list_for_each_entry(x, tmpq, list) {
> 	if (x->ml.cookie == ml->cookie) {
> 	   	lock = x;
> 		break;
> 	}
> }
> 

I agree with you that it's ugly as pants.  Maybe someone could write an
at_list_start() macro?

regards,
dan carpenter

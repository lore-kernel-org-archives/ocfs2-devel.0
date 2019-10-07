From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 7 Oct 2019 21:24:45 +0200
Subject: [Ocfs2-devel] Potential NULL pointer deference in ocfs2
In-Reply-To: <CABvMjLTbBJ-9JrLDi=4B=2MVFCFv95tarS=qe10Pte+=HYSpbw@mail.gmail.com>
References: <CABvMjLTbBJ-9JrLDi=4B=2MVFCFv95tarS=qe10Pte+=HYSpbw@mail.gmail.com>
Message-ID: <20191007192445.GA1163903@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 07, 2019 at 12:09:27PM -0700, Yizhuo Zhai wrote:
> Hi All:
> 
> fs/ocfs2/cluster/heartbeat.c:
> 
> Inside function o2hb_region_start_block_store(), to_o2hb_region()
> could return NULL,however, the return value of to_o2hb_region() is not
> checked and get
> used. This could potentially be unsafe.a

Can you just make a patch and submit it to the proper developers so you
get credit for this?

thanks,

greg k-h

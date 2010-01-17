From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Sun, 17 Jan 2010 16:52:36 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2:freeze-thaw: initialization	and
	cleanup
In-Reply-To: <4B50DFE1.7020800@oracle.com>
References: <201001091802.o09I2ZlW017091@acsinet15.oracle.com>
	<4B4FCA90.1090601@oracle.com>
	<20100115022628.GB3760@laptop.oracle.com>
	<4B4FD49B.6040809@oracle.com>
	<20100115024129.GD3760@laptop.oracle.com>
	<4B50DFE1.7020800@oracle.com>
Message-ID: <20100117085236.GA4015@laptop.domain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

On 10-01-15 13:36, Sunil Mushran wrote:
> Wengang Wang wrote:
>> we don't need to free it when we umount since we don't have that lock taken.
>> we lock/unlock it in mount, and in the downconvert action.
>
> We do have to free the lock. And you are doing it in  
> ocfs2_dlm_shutdown(). ;)
> I was looking at the wrong place. Sorry for the confusion.

Oh, no.
I am sorry too for I had a bad understand.
by "free", you meant real "free", not unlock. and I thought you meant
unlock.

regards,
wengang.

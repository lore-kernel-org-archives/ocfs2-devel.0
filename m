From: Sunil Mushran <sunil.mushran@Oracle.COM>
Date: Tue, 29 Jun 2010 13:22:32 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <AANLkTinqYmN0X4sjaPWbcjhgTApMvdDouXsPAKlcz9PL@mail.gmail.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>	<20100623013633.GC20090@mail.oracle.com>	<AANLkTinvOQGcTDZqtn36ef0lnyLXWy51-XLbM2RR5KJl@mail.gmail.com>	<20100624001437.GF20090@mail.oracle.com>	<AANLkTilj3GhmxKpZ9C5QSh6w7BRYjmU-KQ6hcnSsw6gX@mail.gmail.com>	<20100624005537.GG20090@mail.oracle.com>	<AANLkTinCGO1OrhOPaxbpqY9WtBGMKkf3wrU3uEtYf0JH@mail.gmail.com>	<AANLkTilw7xckG9rpMf9M5NVMNi-PXEw4AXqskPRAVYh0@mail.gmail.com>	<AANLkTilg6R5U1nY7FrsK15bxqNeLTIveUrmhB2p5BKU3@mail.gmail.com>	<AANLkTikqrSWpbqY8aaQhMACpgqN4FlatSzAhJdC3Zpr0@mail.gmail.com>	<AANLkTikJOtSn1ohvfPgCrKEfBOYsmmYDNe_aFUAsGgZb@mail.gmail.com>	<4C2942A4.1050901@oracle.com>	<AANLkTilDa51KeFzhtkT5hbS6z0VBcBkQ2Ni09IuyR19c@mail.gmail.com>	<4C29526E.9090108@oracle.com>	<AANLkTikMbNDKanpd18eIkZlZ9x6WsuZVGSUhR41Y_kYx@mail.gmail.com>	<FD91FB0C-61FF-4E11-9B04-7409954FE188@oracle.com>
	<AANLkTinqYmN0X4sjaPWbcjhgTApMvdDouXsPAKlcz9PL@mail.gmail.com>
Message-ID: <4C2A5608.1040902@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/29/2010 12:43 PM, Patrick J. LoPresti wrote:
> On Mon, Jun 28, 2010 at 9:21 PM, Sunil Mushran<sunil.mushran@oracle.com>  wrote:
>    
>> Yes, that needs to be fixed. Meanwhile you could hand edit the jsb to test
>> your patch.
>>      
> Well, I do not understand the bits well enough to do that...  But I
> did download the source for mkfs.ocfs2 and eliminated its check.
>
> I created a large volume without "-J block64".  With my patch applies,
> the kernel refuses to mount it and generates the appropriate error
> message.
>
> OK to submit my patch to linux-kernel?
>    

Thanks. Mention that in the submission. Submit it to ocfs2-devel.
Joel rounds up all the patches and sends them to Linus during
the merge window.

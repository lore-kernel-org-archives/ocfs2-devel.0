From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 28 Jun 2010 18:54:54 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <AANLkTilDa51KeFzhtkT5hbS6z0VBcBkQ2Ni09IuyR19c@mail.gmail.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>	<20100623004937.GB20090@mail.oracle.com>	<AANLkTilj-EHDdqIN5SziVQXG3WGhvzWGxwKYXCwhTxnM@mail.gmail.com>	<20100623013633.GC20090@mail.oracle.com>	<AANLkTinvOQGcTDZqtn36ef0lnyLXWy51-XLbM2RR5KJl@mail.gmail.com>	<20100624001437.GF20090@mail.oracle.com>	<AANLkTilj3GhmxKpZ9C5QSh6w7BRYjmU-KQ6hcnSsw6gX@mail.gmail.com>	<20100624005537.GG20090@mail.oracle.com>	<AANLkTinCGO1OrhOPaxbpqY9WtBGMKkf3wrU3uEtYf0JH@mail.gmail.com>	<AANLkTilw7xckG9rpMf9M5NVMNi-PXEw4AXqskPRAVYh0@mail.gmail.com>	<AANLkTilg6R5U1nY7FrsK15bxqNeLTIveUrmhB2p5BKU3@mail.gmail.com>	<AANLkTikqrSWpbqY8aaQhMACpgqN4FlatSzAhJdC3Zpr0@mail.gmail.com>	<AANLkTikJOtSn1ohvfPgCrKEfBOYsmmYDNe_aFUAsGgZb@mail.gmail.com>	<4C2942A4.1050901@oracle.com>
	<AANLkTilDa51KeFzhtkT5hbS6z0VBcBkQ2Ni09IuyR19c@mail.gmail.com>
Message-ID: <4C29526E.9090108@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/28/2010 06:15 PM, Patrick J. LoPresti wrote:
> On Mon, Jun 28, 2010 at 5:47 PM, Sunil Mushran<sunil.mushran@oracle.com>  wrote:
>    
>> BTW, have you tested with cleared INCOMPAT_64BIT journal flag?
>>      
> Hm, easier said than done. "tunefs.ocfs2 -J noblock64 ..." bombs out with:
>
> tunefs.ocfs2: Unknown journal option: "block64"
> Valid journal options are:
>          size=<journal-size>
> Usage: tunefs.ocfs2 [options]<device>  [new-size]
> [etc.]
>
> By the way, it complains similarly about "tunefs.ocfs2 -J block64",
> which puts the lie to the failure message in my patch...
>
> When I try to re-format the partition without "-J block64", I get:
>
> ERROR: jbd can only store block numbers in 32 bits. /dev/md0 can hold
> 5082795264 blocks which overflows this limit. If you have a new enough
> Ocfs2 with JBD2 support, you can try formatting with the "-Jblock64"
> option to turn on support for this size block device.
> Otherwise, consider increasing the block size or decreasing the device size.
>    

Which version of tools are you running? block64 was added after 
ocfs2-tools 1.4.2.

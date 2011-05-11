From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 11 May 2011 13:14:31 -0500
Subject: [Ocfs2-devel] [Ocfs2-users] How long for an fsck?
In-Reply-To: <4DB2F701.2010103@oracle.com>
References: <201104211543.29963.guerrero@ice.cat>
	<201104211946.32493.guerrero@ice.cat> <4DB1F431.5070003@oracle.com>
	<201104230024.35576.guerrero@ice.cat> <4DB21BC1.8080704@oracle.com>
	<4DB2E886.5090202@tao.ma> <4DB2F701.2010103@oracle.com>
Message-ID: <BANLkTiknwjh3YE8iX1Y8vebuxtToJKbyzA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On Sat, Apr 23, 2011 at 10:57 AM, Sunil Mushran
<sunil.mushran@oracle.com> wrote:
> On 04/23/2011 07:56 AM, Tao Ma wrote:
>>
>> So what is your version of fsck? I have met with some issue like that
>> when fsck is allocating a large number of memories and it stucks for
>> quite a long time of because of the swapping.
>
> It is not that issue. It is in pass0. I assumed there was a problem
> is in cluster allocation chains. But debugfs managed to scan the
> chain. No loops. Looks ok. So unsure where it could be spinning.
>
> Note it is a 16T, ?4k/4k fs.



We had a similar problem which was fixed by
commit 2d741da9367b33f559802dfabe62d96f6adc7777

Version number would be helpful.

Regards,

-- 
Goldwyn

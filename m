From: Jeff liu <jeff.liu@oracle.com>
Date: Tue, 22 Feb 2011 23:12:06 +0800
Subject: [Ocfs2-devel] forget_all_cached_acls()
In-Reply-To: <4D63B84F.60707@tao.ma>
References: <20110222093212.GF30966@noexit> <4D63B84F.60707@tao.ma>
Message-ID: <39D322B4-E6B1-4962-9337-50E120330D7F@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tao,

? 2011-2-22???9:21? Tao Ma ???

> Hi Joel,
> On 02/22/2011 05:32 PM, Joel Becker wrote:
>> Hey everyone,
>> 	I just found out from Steven over in GFS2 that there is a kernel
>> call forget_all_cached_acls().  If a cluster filesystem is using ACL
>> caching (added by Viro a little while back), they use
>> forget_all_cached_acls() at lock drop time to make sure they don't have
>> stale ACL info.
>> 	We're not using cached_acls yet, but if someone adds it, please
>> remember this call ;-)
>>   
> I remembered that Jeff did some work on it when I was at Oracle.
> So Jeff, did you still work on it now?
I have wrote a patch for catched acl about one and half year ago just for fun.
That patch has been tested on OCFS2 single node at that time,  I will try it on cluster environment with this call.


Thanks,
-Jeff


> 
> Regards,
> Tao

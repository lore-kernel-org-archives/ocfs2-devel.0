From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 15 Jan 2010 10:41:29 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2:freeze-thaw: initialization	and
	cleanup
In-Reply-To: <4B4FD49B.6040809@oracle.com>
References: <201001091802.o09I2ZlW017091@acsinet15.oracle.com>
	<4B4FCA90.1090601@oracle.com>
	<20100115022628.GB3760@laptop.oracle.com>
	<4B4FD49B.6040809@oracle.com>
Message-ID: <20100115024129.GD3760@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

On 10-01-14 18:36, Sunil Mushran wrote:
> Wengang Wang wrote:
>> if you meant ocfs2_freeze_unlock() in ocfs2_umount_volume() instead of
>> at the end of ocfs2_mount_volume(), it's NG.
>> if cleanup when umount, then we always have a ro_holder, freeze/thaw
>> doesn't work.
>>
>> and we dont need to clean it up in umount if we already cleanup it in
>> mount_volume. this is because the lock/unlock is used in pairs.
>>   
>
> What's NG?
>

NG is not good.
> And I am not following you. Don't we have to free all locks during
> umount?

we don't need to free it when we umount since we don't have that lock taken.
we lock/unlock it in mount, and in the downconvert action.

regards,
wengang.

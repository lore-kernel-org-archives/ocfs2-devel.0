From: Xue jiufei <xuejiufei@huawei.com>
Date: Wed, 18 Mar 2015 10:50:25 +0800
Subject: [Ocfs2-devel] [Ocfs2-users] size increase
In-Reply-To: <55094DE0020000D400003494@relay2.provo.novell.com>
References: <CAHW9mbwxOMu5gP8DHW8e65apFaN_+A_gqOG6wV_kUNjVkF2hLg@mail.gmail.com>
	<55094DE0020000D400003494@relay2.provo.novell.com>
Message-ID: <5508E7F1.6070504@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Umarzuki,
What is the meaning of total size, file size or disk usage? 
If you means the disk usage, I think maybe the difference of
cluster size(the minimum allocation unit) is the case.
Have you notice the cluster size or block size of your ocfs2
and ext4 filesystem? 

Thanks,
Xuejiufei

On 2015/3/18 10:05, Zhen Ren wrote:
> Hi Umarzuki,
> 1) Does it always occur, or sometime?
> 
> 2) Could you give more info to reproduce this issue?
> 
> 3) And could you have a try on ext3? Frankly,most of suse people (if I don't make a mistake) use ext3. 
> 
> Also,I add the devel mail list. Hope experts there can help.
> 
> --
> Best regards,
> Eric, Ren
> HA team, SUSE
> 
> 
>>>>
>> I noticed a few folders copied over from ext4 partition to ocfs2 
>> partition increased it total size to more than double. 
>>  
>> Any document explaining this that I could refer to? 
>>  
>> _______________________________________________ 
>> Ocfs2-users mailing list 
>> Ocfs2-users at oss.oracle.com 
>> https://oss.oracle.com/mailman/listinfo/ocfs2-users 
>>  
>>  
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 

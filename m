From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 13 Feb 2014 13:18:46 +0800
Subject: [Ocfs2-devel] [patch 04/11] ocfs2: fix a tiny race when running
	dirop_fileop_racer
In-Reply-To: <20140212232921.GZ24361@wotan.suse.de>
References: <20140124204703.AF70F5A4203@corp2gmr1-2.hot.corp.google.com>
	<20140212232921.GZ24361@wotan.suse.de>
Message-ID: <52FC55B6.7020403@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/2/13 7:29, Mark Fasheh wrote:
>> @@ -1097,6 +1174,22 @@ static int ocfs2_rename(struct inode *ol
>>  			goto bail;
>>  		}
>>  		rename_lock = 1;
>> +
>> +		/* here we cannot guarantee the inodes haven't just been
>> +		 * changed, so check if they are nested again */
>> +		status = ocfs2_check_if_ancestor(osb, new_dir->i_ino,
>> +				old_inode->i_ino);
>> +		if (status < 0) {
>> +			mlog_errno(status);
>> +			goto bail;
>> +		} else if (status == 1) {
>> +			status = -EPERM;
>> +			mlog(ML_ERROR, "src inode %llu should not be ancestor "
>> +				"of new dir inode %llu\n",
>> +				(unsigned long long)old_inode->i_ino,
>> +				(unsigned long long)new_dir->i_ino);
> 
> Is it possible for the user to trigger this mlog(ML_ERROR, "....") print at
> will? If so we need to make it a debug print otherwise we risk blowing up
> systemlog when someone abuses rename().
> 	--Mark
> 
> --
> Mark Fasheh
> 
> 
The nested condition can be constructed but it is rare, isn't it?
And only one system log for one rename, so we log it as error message.

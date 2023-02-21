Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C00C61DA3
	for <ocfs2-devel@archiver.kernel.org>; Tue, 21 Feb 2023 19:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HlpyGwv55ks81zRaWqenyLk0AMt61ZqCS5NACaLpbTM=;
 b=hzjez1af7+rNs32pWFrSBm4gCOYIgv5OzmjcNR1iiiSxVIsGPzeb43N3r5WhPLIEMwhUTE97nhAn
   KQ76O/xQ6BNSLO7IaqcFW7XHT04BttccwylBDJa3/89RHhIGYbQdDoris5cl0Y0qnzM2gSEImPHb
   cZ8zOHU5NUPQA60qmbvKcsYZ7kWQ2rmQzYiKFOEfrQ7ho1i5YuItecrXz4pXFgsUjBySioKDJwjp
   t1Pv1GRAAyYhC+iCPoD1Jg/8oGfh28LHRdZUHW+xk7n6uTJy20GvL+sn0KVlWvQApgA0mc42KYVI
   oV9KArV0+traEvxSrobcXXtzDC1tzk5hGpG75g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HlpyGwv55ks81zRaWqenyLk0AMt61ZqCS5NACaLpbTM=;
 b=tTk3cvH4ZkjI7Xl408hd9ksVos1b0c0cC2+DbNNUJxi3euD3TWhffL5d1vBTpdX+65Vc0nYZ8Fk2
   clJc38K+Jgu8Rs1vZ5Bq+zxxVK/7o106aWJJOtC3obEsCPcbTKnx9gYD3d7ewNuqib4DvCxKnv/e
   bfcwR8GICBhxLJ3ZQVVXzSX3fLuX5fDboE4jxaQ24jkwE3EpJCnZYXbHBirrkX/+LOHoaii4BBDc
   rg+MjlN60WFFUSXAFDs+Sr31AbEdjaQmPSjP0GRDsTCG0cnctsR067q6TAYi0C52KI9KbFkcb1kV
   7hgEgeaRc0axeav66TdQJDJ7cSHU8NsaBtI+hQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQG006TW3GB3L40@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 21 Feb 2023 19:28:59 +0000 (GMT)
Message-id: <d5180ef2-70dc-0a43-3e1b-c04d9e14ab23@linux.alibaba.com>
Date: Tue, 21 Feb 2023 14:45:50 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
 <6905166125130c22c244ebf234723d1587a01ae8.camel@huaweicloud.com>
In-reply-to: <6905166125130c22c244ebf234723d1587a01ae8.camel@huaweicloud.com>
X-Source-IP: 115.124.30.99
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10627
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 clxscore=16
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 priorityscore=111 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210059 domainage_hfrom=8713
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 2/6] ocfs2: Switch to
	security_inode_init_security()
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045170;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=20; SR=0;
 TI=SMTPD_---0VcB88ba_1676961950;
X-ServerName: out30-99.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: GUygIp4i1_cY7eSN3X-vebz2Uc7t-5Zf
X-Proofpoint-ORIG-GUID: GUygIp4i1_cY7eSN3X-vebz2Uc7t-5Zf
Reporting-Meta:
 AAEjYfnlwo0fy7CWEz7GUS/qvwTEpw1FS8J4mlq1XkebQLRgcKg5Y4juYeVyzV6l
 HgN5+5OkSv27U/nDdRM5d019/06p816Y+SgYA5H1Jno2vW5GAi2490KtmH6Yv5Rg
 R/4nQuKreUixsxtv2ha8lprLyRK6EB8J4BRzEalaG36FUhPNB89gS1CDjj+N3zGC
 GmzdBxod5APJgddm6dINCMpUvi1HxvOU1/eWbyr/SQT8/I25bTJSixJCbcd+HNzZ
 DzKfJlATXxhSIj5Uvp1h2GGZQaRB+EC6XQfNljKQpTCMPu7bt55zyWHpKckycuFt
 7lwHmXpwr+MpFp11ay7DvqKFj0kOZbcATRhXNjiYVp/pXwmbM8ju9+O/WqNsJcK4
 BHYyRBOnecEvjvyrYrPybkfO5z2v8t25HjgR1EoKgILnw6cuctkBQOP5b1TdScvE
 dXdGjCw2T4YgpPoMbcik/1pZLrQhoHlo+HP3G7R7L1HH58nKe3ScQeeSZxhYqEZo
 yCvtZW19TB1/vxaVrV8C6U/QrcIsWWN4vFQTMpzh3Zk=

Hi,

Sorry for the late reply.

I don't have much background on this thread. It seems that we have to
check EOPNOTSUPP since ocfs2_init_security_get() may return EOPNOTSUPP
if it doesn't support extended attribute feature for backward
compatibility.

Other looks good. So with above comments addressed, you can add:
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

On 1/10/23 4:55 PM, Roberto Sassu wrote:
> On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
>> From: Roberto Sassu <roberto.sassu@huawei.com>
>>
>> In preparation for removing security_old_inode_init_security(), switch to
>> security_inode_init_security().
>>
>> Extend the existing ocfs2_initxattrs() to take the
>> ocfs2_security_xattr_info structure from fs_info, and populate the
>> name/value/len triple with the first xattr provided by LSMs.
> 
> Hi Mark, Joel, Joseph
> 
> some time ago I sent this patch set to switch to the newer
> function security_inode_init_security(). Almost all the other parts of
> this patch set have been reviewed, and the patch set itself should be
> ready to be merged.
> 
> I kindly ask if you could have a look at this patch and give your
> Reviewed-by, so that Paul could take the patch set.
> 
> Thanks a lot!
> 
> Roberto
> 
>> As fs_info was not used before, ocfs2_initxattrs() can now handle the case
>> of replicating the behavior of security_old_inode_init_security(), i.e.
>> just obtaining the xattr, in addition to setting all xattrs provided by
>> LSMs.
>>
>> Supporting multiple xattrs is not currently supported where
>> security_old_inode_init_security() was called (mknod, symlink), as it
>> requires non-trivial changes that can be done at a later time. Like for
>> reiserfs, even if EVM is invoked, it will not provide an xattr (if it is
>> not the first to set it, its xattr will be discarded; if it is the first,
>> it does not have xattrs to calculate the HMAC on).
>>
>> Finally, modify the handling of the return value from
>> ocfs2_init_security_get(). As security_inode_init_security() does not
>> return -EOPNOTSUPP, remove this case and directly handle the error if the
>> return value is not zero.
>>
>> However, the previous case of receiving -EOPNOTSUPP should be still
>> taken into account, as security_inode_init_security() could return zero
>> without setting xattrs and ocfs2 would consider it as if the xattr was set.
>>
>> Instead, if security_inode_init_security() returned zero, look at the xattr
>> if it was set, and behave accordingly, i.e. set si->enable to zero to
>> notify to the functions following ocfs2_init_security_get() that the xattr
>> is not available (same as if security_old_inode_init_security() returned
>> -EOPNOTSUPP).
>>
>> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
>> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
>> ---
>>  fs/ocfs2/namei.c | 18 ++++++------------
>>  fs/ocfs2/xattr.c | 30 ++++++++++++++++++++++++++----
>>  2 files changed, 32 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>> index 05f32989bad6..55fba81cd2d1 100644
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -242,6 +242,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
>>  	int want_meta = 0;
>>  	int xattr_credits = 0;
>>  	struct ocfs2_security_xattr_info si = {
>> +		.name = NULL,
>>  		.enable = 1,
>>  	};
>>  	int did_quota_inode = 0;
>> @@ -315,12 +316,8 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
>>  	/* get security xattr */
>>  	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
>>  	if (status) {
>> -		if (status == -EOPNOTSUPP)
>> -			si.enable = 0;
>> -		else {
>> -			mlog_errno(status);
>> -			goto leave;
>> -		}
>> +		mlog_errno(status);
>> +		goto leave;
>>  	}
>>  
>>  	/* calculate meta data/clusters for setting security and acl xattr */
>> @@ -1805,6 +1802,7 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
>>  	int want_clusters = 0;
>>  	int xattr_credits = 0;
>>  	struct ocfs2_security_xattr_info si = {
>> +		.name = NULL,
>>  		.enable = 1,
>>  	};
>>  	int did_quota = 0, did_quota_inode = 0;
>> @@ -1875,12 +1873,8 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
>>  	/* get security xattr */
>>  	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
>>  	if (status) {
>> -		if (status == -EOPNOTSUPP)
>> -			si.enable = 0;
>> -		else {
>> -			mlog_errno(status);
>> -			goto bail;
>> -		}
>> +		mlog_errno(status);
>> +		goto bail;
>>  	}
>>  
>>  	/* calculate meta data/clusters for setting security xattr */
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 95d0611c5fc7..55699c573541 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -7259,9 +7259,21 @@ static int ocfs2_xattr_security_set(const struct xattr_handler *handler,
>>  static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
>>  		     void *fs_info)
>>  {
>> +	struct ocfs2_security_xattr_info *si = fs_info;
>>  	const struct xattr *xattr;
>>  	int err = 0;
>>  
>> +	if (si) {
>> +		si->value = kmemdup(xattr_array->value, xattr_array->value_len,
>> +				    GFP_KERNEL);
>> +		if (!si->value)
>> +			return -ENOMEM;
>> +
>> +		si->name = xattr_array->name;
>> +		si->value_len = xattr_array->value_len;
>> +		return 0;
>> +	}
>> +
>>  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
>>  		err = ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
>>  				      xattr->name, xattr->value,
>> @@ -7277,13 +7289,23 @@ int ocfs2_init_security_get(struct inode *inode,
>>  			    const struct qstr *qstr,
>>  			    struct ocfs2_security_xattr_info *si)
>>  {
>> +	int ret;
>> +
>>  	/* check whether ocfs2 support feature xattr */
>>  	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
>>  		return -EOPNOTSUPP;
>> -	if (si)
>> -		return security_old_inode_init_security(inode, dir, qstr,
>> -							&si->name, &si->value,
>> -							&si->value_len);
>> +	if (si) {
>> +		ret = security_inode_init_security(inode, dir, qstr,
>> +						   &ocfs2_initxattrs, si);
>> +		/*
>> +		 * security_inode_init_security() does not return -EOPNOTSUPP,
>> +		 * we have to check the xattr ourselves.
>> +		 */
>> +		if (!ret && !si->name)
>> +			si->enable = 0;
>> +
>> +		return ret;
>> +	}
>>  
>>  	return security_inode_init_security(inode, dir, qstr,
>>  					    &ocfs2_initxattrs, NULL);

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel

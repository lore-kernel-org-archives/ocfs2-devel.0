Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FA3C433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 17:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=thxVC6pbLGPPqfoTIJIHfTR0j3NJWHIoMr/97R5uL9s=;
 b=p+ltXxX/JLhhdIi4vB+Tqfkvo/QeYmPM8xny55CAIwZu0QPbSDREm2iTzZ3TUXVohiYRtYhrFUEM
   ArjX4Kx7R1bohPY+l0JBHj7pLdpoY9PLYtOZ91opDIUU84FjrOQEJRppnPzZs9ywvQvaCg+H3drv
   Fu/LAUEuLpE6YH3pvoeyCFR5TnB9qloJAEsFZNc2besel5yJtkRXviQ/RYbNOc0ZsxpKwHNlI0cf
   ceAeKrH3gaDUxqHDq81rHEu/KSn0uZSsETWJOsE9D7iKKBs1nhMTgP0JPNL+DqDAhTtZ3XE9eYHd
   LYxLPfPZH24KuyZCF2jJ3zbOltgOhBWPifb8EQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=thxVC6pbLGPPqfoTIJIHfTR0j3NJWHIoMr/97R5uL9s=;
 b=jt/S+Ce0b9V0BhVrAojZxzhvaDHJyrfIBKoE4nJ1qFs5VT40t1b7hJudMpqBIq2b+j9CzYlDnJLP
   Ei+btetM2q0Tlv6Wcc0oZD4AmG5tNlEH4cBI/D+VBbzPa2J7l34jbJQM6NOhjlMWtmaLYGh5oL+G
   YoKSlTcy3t6CFhK6Kzo549fs/FgrhuiHkFBPgWVCfHYdk5DWVHJC3JhDS/B7XtuDV9JKzx1w2n2G
   wu8xat2rD3KMuT2bo1KuFXI/uZ3enbZXRBnmmfSwLsuKXAPgroUOcaAPdoIKxlFSsJ+Jivj7ZUpz
   vQkw6HVSWdAOI3kJBi2McOHk67w5XQ/B1uiZfg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLT00EGH9D3DU90@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 17:17:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
 t=1669223832; bh=9BI0WqEg/J8uZZ2nld6CrIGO8vM4bZEIj91ZlyjWVHU=;
 h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To;
 b=Gh119z4IPcUm6bBkODAlIrthxwaz022TxJUGLPDs8yJjF+Lzvb1naRF76pKi9OFQ6SCAD24AZFf9vjhsJu11HT2CftTGyUjyXSf1KcmBaMDqxF/mr67g0biTITj+aJpIOqTfgn0wGCTUMsEFK3e4roa1ooHaMcj7oSTaeheweLJcPSVB++ckh4QN3xozE5QKsHWNRPGsOcUrXkg4sDTACqOxlk2fzjnx6jFzTmz0EgCdYf5111fKygkA1zs4bwH+u6nSDbbZ4l6OWKtOoszIJgHddR0WctFheSLhDrx58zT0eh5hclFskQ+UrNoM5UEBkehevn2qnoC9uU3rGlEnXA==
Message-id: <7eaacdff-521e-c30f-8ca0-3791a5dc4d45@schaufler-ca.com>
Date: Wed, 23 Nov 2022 09:17:04 -0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-language: en-US
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, zohar@linux.ibm.com,
 dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
 serge@hallyn.com, stephen.smalley.work@gmail.com, eparis@parisplace.org
References: <20221123154712.752074-1-roberto.sassu@huaweicloud.com>
 <20221123154712.752074-5-roberto.sassu@huaweicloud.com>
In-reply-to: <20221123154712.752074-5-roberto.sassu@huaweicloud.com>
X-Mailer: WebService/1.1.20863
 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Source-IP: 66.163.184.49
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10540
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0 clxscore=120
 bulkscore=0 mlxscore=0 priorityscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230128
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 linux-integrity@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v6 4/6] security: Allow all LSMs to provide
 xattrs for inode_init_security hook
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
From: Casey Schaufler via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Casey Schaufler <casey@schaufler-ca.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
 t=1669223832; bh=Bx0aG5gaiV0IQTxrqIbItbpj7V8Yl6K0Oy4ubQMhWWC=;
 h=X-Sonic-MF:Date:Subject:To:From:From:Subject;
 b=rToeRgli+7cy+p99hbKaGrvsB4uJDrxZ0Nql6MWPbeTXMqXxCX6bagsrEmqXikJ0LAL3jNxeXkXQkXJHSPd51BQosvvjbBh3U+wawh0wR/M5kK0fh++1KJmq+mXAdbrW5GET840kUXhVN26lFNBNsxHjt4pJS0N1rY5VpE1jNHWEot0Oq2fI9ioVMA9BwJc+w5N73Gf1NhD8Nk3pvuJSQJhSxXl0eup5yCg0DltdzVcjGvEqlb36gQahmA3x/HuJ8YB/B+K/tOxa1T9rtHfrDIItcpgsYgjNYCJkCeN5wyJy2FiA+Yxf9mN2OeGNwABosLi0EGaHWaCC3lVYJoAoNw==
X-YMail-OSG: 9IWJi7QVM1m.zI6TlqcZukC.L1MqBdbGvdbEcGgP.SUlfQdzglbLf7e5dhoYXV3
 zoVSBWij_R.f8_umOOnrCaIHWiXjytPszYiU6YB_Nw1rQgSi3izObgtizwlngE6tdmNbrYi25zfP
 7VpkbsBWf4RDiOlpWdVVcz2LYOCNb9pIr7Tu7kD02SrvUnNUdV3Jglj8UNFdMFWdrB879pPIGCZB
 VcQhv2l8nyWyvK4CFZNDuiP.9hhEOJdFInXKSMu7B5sdgRn3EyzczyqFI9X0.5.BUyV5d60au9yx
 ylSY0g_oTbFiXSkizscO5fa2htaweFRYpYNQO72qilXMLL1bmLKCejCUxWEPhUiKLYiHEczwsj8h
 ukLikeuMLjsgJfZZ5cUavVTk_4MtIWjySlxAflaBSkmkw0lRlAXCFD2fNX4Qn7KY.fCJTuAqPcO8
 SMQ20o7RYqP0wIA2Vrn1V1ljsrkuc7fAtqNPCMUQyOIb.brXnKNMYmmEXmjxmvDZDyad1y6XZijf
 Pey8y6jhjfMtjQju2zydtydeVMQiU3FqCxz0pwtHRUIMFNILIkzZaM_GirOvZhN_j_giZKnUwsQA
 en8bQLu3vNawho_DgzbyRjCJA3GA.hWFqe51akl9bpJl8WJxLukYvyCUxmU0NcF0knR18QsIIWVa
 ash5N0kAP5Ibg.ExitClbs_2vbFwIHIQfTOeTwxJQ6I7SazKZXXCrbMDSJ5_qFOW1LMI8iY0FXNX
 3cVN35IK.n55av11JxWX0XjO9uSNPWQG0M.sLcLb53TSlCDSiHXZfXxAR5ErpyWMcoYsowg1ppGn
 gpvBdmNN6Nu7HJeGCYUqdpT8dWwweiFy9ubgcrAx5CbAUjjbvmSpjmQlYhZoffddjZracFLdXRoC
 q.Q5rS.kS7IZHyl83y.1JDXjkswBp4xcKxvlP5YCbxJhoTuTMHiUoOtiQEFjLbEhlrK3pKe3q4os
 vcZw.jA5mqHSIJcBAW6HG9C5ATlpILygkbaJ17dwMavsPj4VKImmpKabC15IKuhR7IghuZrydKss
 4zmxUq0VqsHeiWc4.eGo7vYillJ_s62XNvCgl7S6G9IaS5KgELpq2YzQFKhE42Og_s6CYqoR2A9A
 BuNZmr7Wb5uQalL10eDSKCrh85dmgL98XrLxEKsb4xGk.UzkBjkfn4Lgesf8ENo9t_r9iJ3vxUwR
 2IOn3fDFrFy4RjfgSTvhkVrV7syTEX1IrqMlabaaEskixy7Z8xw8C9uFTGXXIkbXeuazhxfSdmnr
 7kycUXuHJZEEdijlZrraD.qLhGL0BSUdmM_8_ykUtKK4mweqMBmDojlLBsby.EqUG9vMWHrtjeXc
 1rXBd8Z1y7lt4h7mPUFf6Uljz8AZ5r7lGf6.xo12PJ9H4xm4s6f2oR5sozbCZ_nxq6ajQtAyMATR
 TxobToMppFa7kTiAqozojbQcGgxRzAmVyooexBK3Gw9Tuh4FdERQBdZHjUp37dzrF7IeajmD0X5J
 PmYL4LrEXkQ9OkB0joa9Tn6DO9EhSCulT7DKfKemHl8SQHyIn..aw8UCrrsa4tMl19av2Nr4sF7p
 xnLcAMUxFHBCIbpRjl931OnebVtiNR6O7h1RNVyyPHRlEnl5KqZ_ekKS4z9h_MPUVKF3OctQ4DyB
 wGiJ.lvZLXs1X5lOdDyMkmcZE9wS.zlZcw575JEDiIgH7A9bNZE2UicUdkCuM3dX8BwspFImbxuA
 hswK3BecjhcrmLro678XlnICsM8l2wBcm_o7l2s7ZSgWrFmapkQi1ihkZKxa7QsoVnN1C_Bkh5gC
 ohgz0bVfhyAoT2mulvQITfMTHFZ7XiT2IA2d5Ea5MSEh1e2xYtg8sDAePhW8wLOu_.tTAmbgquS6
 9TjiUsnwr84eG3kbYdrh9SJEtsF26lqMaIBhxZ4WdE_3btvckVmCxjgmzY65qbI2ZbjAH.Jon9sI
 FYfaUhgS6Bf6l3uZW2Y56SrF0fnpEI0FZFc18tPfL0lczYzWU45XS_D35BfZk8MwSKYI_bGBkcjR
 kCtStqgGIP74mdjCCPO4jGPDagHAewDDKRHIlBvL_voxDA9DUBn5Xnh8uxP6EMlPUn9rhpg5A6NC
 Tp12knNM.lVLHElcrkMOGOcSu7CEfHmY8pJ6s9WIx.sfga95RB3.zX1Vtx9HFEOxc0rjmCHOCbAs
 CzpW7jYW2Vk4Oar7JK8XMvJrvPNMX6PpgTdA0F2YUxh3ONbAyB9K8emZ6eMkUAwekpiZyFlCjljK
 lk_SxeUfwRTchbl8YCZ8DtgTVLpOkd_biJtE-
X-Sonic-MF: <casey@schaufler-ca.com>
X-ServerName: sonic317-38.consmr.mail.ne1.yahoo.com
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: dEeXyWUBBS1dEbFRj6R2aUE0-V-5Kwd7
X-Proofpoint-ORIG-GUID: dEeXyWUBBS1dEbFRj6R2aUE0-V-5Kwd7
Reporting-Meta:
 AAED6ipOTUBuGY7l38Oh76j+1dJPQfoA8GcfzlbGLbW2PHbVt0y0Im/+Wjolivwo
 pTc/yTP9sC4xNmjqUcqZqLK4wry/Md5jy4o6vh5uDpvPRGnvHdB0FVyJmtj2SjgN
 eYNUlHpdqSOPxyFfYXnE/zAMfXWbKkKNyRY8W5Ip5B9A+GvY675AEXPk5mu6b2gm
 pERDqp36ExuruCoj8rZm6lBITFQTYvmUjVdTvdU6jA8KDpi5yQlvzOTONQb8Xqt3
 tJpjf0oXB5XLWk0OHy8TguNlSxTprwzVubL5lu7aPNmS3bULIeMnaNJUhAZ6OM2R
 dtds/yb4pNhKqcgpGYCDMWKXRAQv8p+Cru4hRPPNlQJcwrsb0Q3b+y/Y9PLhxXPq
 wIKs5ytK5j7M2EQDErUQ00pr1RXXgbyjU3KQ07pZXmAg3wwrCTFixfyDcIhoqwfC
 2iw/uSpuppTxz5kmonxdzplHtuDZr/Ol0rflztBWvncWYbGCdO1rBQ4Y6CdERsPr
 aWbeLaHhMHMd5soiK3cynRracM3EUJFhskFdL96CdibJ

On 11/23/2022 7:47 AM, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> Currently, security_inode_init_security() supports only one LSM providing
> an xattr and EVM calculating the HMAC on that xattr, plus other inode
> metadata.
>
> Allow all LSMs to provide one or multiple xattrs, by extending the security
> blob reservation mechanism. Introduce the new lbs_xattr field of the
> lsm_blob_sizes structure, so that each LSM can specify how many xattrs it
> needs, and the LSM infrastructure knows how many xattr slots it should
> allocate.
>
> Dynamically allocate the xattrs array to be populated by LSMs with the
> inode_init_security hook, and pass it to the latter instead of the
> name/value/len triple. Update the documentation accordingly, and fix the
> description of the xattr name, as it is not allocated anymore.
>
> Since the LSM infrastructure, at initialization time, updates the number of
> the requested xattrs provided by each LSM with a corresponding offset in
> the security blob (in this case the xattr array), it makes straightforward
> for an LSM to access the right position in the xattr array.
>
> There is still the issue that an LSM might not fill the xattr, even if it
> requests it (legitimate case, for example it might have been loaded but not
> initialized with a policy). Since users of the xattr array (e.g. the
> initxattrs() callbacks) detect the end of the xattr array by checking if
> the xattr name is NULL, not filling an xattr would cause those users to
> stop scanning xattrs prematurely.
>
> Solve that issue by introducing security_check_compact_filled_xattrs(),
> which does a basic check of the xattr array (if the xattr name is filled,
> the xattr value should be too, and viceversa), and compacts the xattr array
> by removing the holes.
>
> An alternative solution would be to let users of the xattr array know the
> number of elements of that array, so that they don't have to check the
> termination. However, this seems more invasive, compared to a simple move
> of few array elements.
>
> security_check_compact_filled_xattrs() also determines how many xattrs in
> the xattr array have been filled. If there is none, skip
> evm_inode_init_security() and initxattrs(). Skipping the former also avoids
> EVM to crash the kernel, as it is expecting a filled xattr.
>
> Finally, adapt both SELinux and Smack to use the new definition of the
> inode_init_security hook, and to correctly fill the designated slots in the
> xattr array. For Smack, reserve space for the other defined xattrs although
> they are not set yet in smack_inode_init_security().
>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  include/linux/lsm_hook_defs.h |   3 +-
>  include/linux/lsm_hooks.h     |  17 ++++--
>  security/security.c           | 103 +++++++++++++++++++++++++++++-----
>  security/selinux/hooks.c      |  19 ++++---
>  security/smack/smack_lsm.c    |  26 +++++----
>  5 files changed, 127 insertions(+), 41 deletions(-)
>
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index ec119da1d89b..be344d0211f8 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -112,8 +112,7 @@ LSM_HOOK(int, 0, path_notify, const struct path *path, u64 mask,
>  LSM_HOOK(int, 0, inode_alloc_security, struct inode *inode)
>  LSM_HOOK(void, LSM_RET_VOID, inode_free_security, struct inode *inode)
>  LSM_HOOK(int, 0, inode_init_security, struct inode *inode,
> -	 struct inode *dir, const struct qstr *qstr, const char **name,
> -	 void **value, size_t *len)
> +	 struct inode *dir, const struct qstr *qstr, struct xattr *xattrs)
>  LSM_HOOK(int, 0, inode_init_security_anon, struct inode *inode,
>  	 const struct qstr *name, const struct inode *context_inode)
>  LSM_HOOK(int, 0, inode_create, struct inode *dir, struct dentry *dentry,
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 4ec80b96c22e..ba1655370643 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -229,18 +229,22 @@
>   *	This hook is called by the fs code as part of the inode creation
>   *	transaction and provides for atomic labeling of the inode, unlike
>   *	the post_create/mkdir/... hooks called by the VFS.  The hook function
> - *	is expected to allocate the name and value via kmalloc, with the caller
> - *	being responsible for calling kfree after using them.
> + *	is expected to allocate the value via kmalloc, with the caller
> + *	being responsible for calling kfree after using it.
>   *	If the security module does not use security attributes or does
>   *	not wish to put a security attribute on this particular inode,
>   *	then it should return -EOPNOTSUPP to skip this processing.
>   *	@inode contains the inode structure of the newly created inode.
>   *	@dir contains the inode structure of the parent directory.
>   *	@qstr contains the last path component of the new object
> - *	@name will be set to the allocated name suffix (e.g. selinux).
> - *	@value will be set to the allocated attribute value.
> - *	@len will be set to the length of the value.
> - *	Returns 0 if @name and @value have been successfully set,
> + *	@xattrs contains the full array of xattrs provided by LSMs where
> + *	->name will be set to the name suffix (e.g. selinux).
> + *	->value will be set to the allocated attribute value.
> + *	->value_len will be set to the length of the value.
> + *	Slots in @xattrs need to be reserved by LSMs by providing the number of
> + *	the desired xattrs in the lbs_xattr field of the lsm_blob_sizes
> + *	structure.
> + *	Returns 0 if the requested slots in @xattrs have been successfully set,
>   *	-EOPNOTSUPP if no security attribute is needed, or
>   *	-ENOMEM on memory allocation failure.
>   * @inode_init_security_anon:
> @@ -1624,6 +1628,7 @@ struct lsm_blob_sizes {
>  	int	lbs_ipc;
>  	int	lbs_msg_msg;
>  	int	lbs_task;
> +	int	lbs_xattr;
>  };
>  
>  /*
> diff --git a/security/security.c b/security/security.c
> index e2857446fd32..26aaa5850867 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -30,8 +30,6 @@
>  #include <linux/msg.h>
>  #include <net/flow.h>
>  
> -#define MAX_LSM_EVM_XATTR	2
> -
>  /* How many LSMs were built into the kernel? */
>  #define LSM_COUNT (__end_lsm_info - __start_lsm_info)
>  
> @@ -210,6 +208,7 @@ static void __init lsm_set_blob_sizes(struct lsm_blob_sizes *needed)
>  	lsm_set_blob_size(&needed->lbs_msg_msg, &blob_sizes.lbs_msg_msg);
>  	lsm_set_blob_size(&needed->lbs_superblock, &blob_sizes.lbs_superblock);
>  	lsm_set_blob_size(&needed->lbs_task, &blob_sizes.lbs_task);
> +	lsm_set_blob_size(&needed->lbs_xattr, &blob_sizes.lbs_xattr);
>  }
>  
>  /* Prepare LSM for initialization. */
> @@ -346,6 +345,7 @@ static void __init ordered_lsm_init(void)
>  	init_debug("msg_msg blob size    = %d\n", blob_sizes.lbs_msg_msg);
>  	init_debug("superblock blob size = %d\n", blob_sizes.lbs_superblock);
>  	init_debug("task blob size       = %d\n", blob_sizes.lbs_task);
> +	init_debug("xattr slots          = %d\n", blob_sizes.lbs_xattr);
>  
>  	/*
>  	 * Create any kmem_caches needed for blobs
> @@ -1089,37 +1089,110 @@ int security_dentry_create_files_as(struct dentry *dentry, int mode,
>  }
>  EXPORT_SYMBOL(security_dentry_create_files_as);
>  
> +/**
> + * security_check_compact_filled_xattrs - check xattrs and make array contiguous
> + * @xattrs: xattr array filled by LSMs
> + * @num_xattrs: length of xattr array
> + * @num_filled_xattrs: number of already processed xattrs
> + *
> + * Ensure that each xattr slot is correctly filled and close the gaps in the
> + * xattr array if an LSM didn't provide an xattr for which it asked space
> + * (legitimate case, it might have been loaded but not initialized). An LSM
> + * might request space in the xattr array for one or multiple xattrs. The LSM
> + * infrastructure ensures that all requests by LSMs are satisfied.
> + *
> + * Track the number of filled xattrs in @num_filled_xattrs, so that it is easy
> + * to determine whether the currently processed xattr is fine in its position
> + * (if all previous xattrs were filled) or it should be moved after the last
> + * filled xattr.
> + *
> + * Return: zero if all xattrs are valid, -EINVAL otherwise.
> + */
> +static int security_check_compact_filled_xattrs(struct xattr *xattrs,
> +						int num_xattrs,
> +						int *num_filled_xattrs)
> +{
> +	int i;
> +
> +	for (i = *num_filled_xattrs; i < num_xattrs; i++) {
> +		if ((!xattrs[i].name && xattrs[i].value) ||
> +		    (xattrs[i].name && !xattrs[i].value))
> +			return -EINVAL;
> +
> +		if (!xattrs[i].name)
> +			continue;
> +
> +		if (i == *num_filled_xattrs) {
> +			(*num_filled_xattrs)++;
> +			continue;
> +		}
> +
> +		memcpy(xattrs + (*num_filled_xattrs)++, xattrs + i,
> +		       sizeof(*xattrs));
> +		memset(xattrs + i, 0, sizeof(*xattrs));
> +	}
> +
> +	return 0;
> +}
> +
>  int security_inode_init_security(struct inode *inode, struct inode *dir,
>  				 const struct qstr *qstr,
>  				 const initxattrs initxattrs, void *fs_data)
>  {
> -	struct xattr new_xattrs[MAX_LSM_EVM_XATTR + 1];
> -	struct xattr *lsm_xattr, *evm_xattr, *xattr;
> -	int ret;
> +	struct security_hook_list *P;
> +	struct xattr *new_xattrs;
> +	struct xattr *xattr;
> +	int ret = -EOPNOTSUPP, num_filled_xattrs = 0;
>  
>  	if (unlikely(IS_PRIVATE(inode)))
>  		return 0;
>  
> +	if (!blob_sizes.lbs_xattr)
> +		return 0;
> +
>  	if (!initxattrs)
>  		return call_int_hook(inode_init_security, -EOPNOTSUPP, inode,
> -				     dir, qstr, NULL, NULL, NULL);
> -	memset(new_xattrs, 0, sizeof(new_xattrs));
> -	lsm_xattr = new_xattrs;
> -	ret = call_int_hook(inode_init_security, -EOPNOTSUPP, inode, dir, qstr,
> -						&lsm_xattr->name,
> -						&lsm_xattr->value,
> -						&lsm_xattr->value_len);
> -	if (ret)
> +				    dir, qstr, NULL);
> +	/* Allocate +1 for EVM and +1 as terminator. */
> +	new_xattrs = kcalloc(blob_sizes.lbs_xattr + 2, sizeof(*new_xattrs),
> +			     GFP_NOFS);
> +	if (!new_xattrs)
> +		return -ENOMEM;
> +
> +	hlist_for_each_entry(P, &security_hook_heads.inode_init_security,
> +			     list) {
> +		ret = P->hook.inode_init_security(inode, dir, qstr, new_xattrs);
> +		if (ret && ret != -EOPNOTSUPP)
> +			goto out;
> +		if (ret == -EOPNOTSUPP)
> +			continue;
> +		/*
> +		 * As the number of xattrs reserved by LSMs is not directly
> +		 * available, directly use the total number blob_sizes.lbs_xattr
> +		 * to keep the code simple, while being not the most efficient
> +		 * way.
> +		 */
> +		ret = security_check_compact_filled_xattrs(new_xattrs,
> +							   blob_sizes.lbs_xattr,
> +							   &num_filled_xattrs);
> +		if (ret < 0) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +	}
> +
> +	if (!num_filled_xattrs)
>  		goto out;
>  
> -	evm_xattr = lsm_xattr + 1;
> -	ret = evm_inode_init_security(inode, lsm_xattr, evm_xattr);
> +	ret = evm_inode_init_security(inode, new_xattrs,
> +				      new_xattrs + num_filled_xattrs);
>  	if (ret)
>  		goto out;
>  	ret = initxattrs(inode, new_xattrs, fs_data);
>  out:
>  	for (xattr = new_xattrs; xattr->value != NULL; xattr++)
>  		kfree(xattr->value);
> +	kfree(new_xattrs);
>  	return (ret == -EOPNOTSUPP) ? 0 : ret;
>  }
>  EXPORT_SYMBOL(security_inode_init_security);
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index f553c370397e..57e5bc7c9ed8 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -104,6 +104,8 @@
>  #include "audit.h"
>  #include "avc_ss.h"
>  
> +#define SELINUX_INODE_INIT_XATTRS 1
> +
>  struct selinux_state selinux_state;
>  
>  /* SECMARK reference count */
> @@ -2868,11 +2870,11 @@ static int selinux_dentry_create_files_as(struct dentry *dentry, int mode,
>  
>  static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
>  				       const struct qstr *qstr,
> -				       const char **name,
> -				       void **value, size_t *len)
> +				       struct xattr *xattrs)
>  {
>  	const struct task_security_struct *tsec = selinux_cred(current_cred());
>  	struct superblock_security_struct *sbsec;
> +	struct xattr *xattr = NULL;
>  	u32 newsid, clen;
>  	int rc;
>  	char *context;
> @@ -2899,16 +2901,18 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
>  	    !(sbsec->flags & SBLABEL_MNT))
>  		return -EOPNOTSUPP;
>  
> -	if (name)
> -		*name = XATTR_SELINUX_SUFFIX;
> +	if (xattrs)
> +		xattr = xattrs + selinux_blob_sizes.lbs_xattr;
> +
> +	if (xattr) {
> +		xattr->name = XATTR_SELINUX_SUFFIX;
>  
> -	if (value && len) {
>  		rc = security_sid_to_context_force(&selinux_state, newsid,
>  						   &context, &clen);
>  		if (rc)
>  			return rc;
> -		*value = context;
> -		*len = clen;
> +		xattr->value = context;
> +		xattr->value_len = clen;
>  	}
>  
>  	return 0;
> @@ -6900,6 +6904,7 @@ struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
>  	.lbs_ipc = sizeof(struct ipc_security_struct),
>  	.lbs_msg_msg = sizeof(struct msg_security_struct),
>  	.lbs_superblock = sizeof(struct superblock_security_struct),
> +	.lbs_xattr = SELINUX_INODE_INIT_XATTRS,
>  };
>  
>  #ifdef CONFIG_PERF_EVENTS
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index b6306d71c908..a7c3e4284754 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -52,6 +52,8 @@
>  #define SMK_RECEIVING	1
>  #define SMK_SENDING	2
>  

How about a comment here to answer the inevitable "What 4 attributes?" question.

+/*
+ * Smack uses multiple xattrs.
+ * SMACK64 - for access control, SMACK64EXEC - label for the program,
+ * SMACK64MMAP - controls library loading, SMACK64TRANSMUTE - label initialization
+ * Not saved on files - SMACK64IPIN and SMACK64IPOUT
+ */

> +#define SMACK_INODE_INIT_XATTRS 4
> +
>  #ifdef SMACK_IPV6_PORT_LABELING
>  static DEFINE_MUTEX(smack_ipv6_lock);
>  static LIST_HEAD(smk_ipv6_port_list);
> @@ -939,26 +941,27 @@ static int smack_inode_alloc_security(struct inode *inode)
>   * @inode: the newly created inode
>   * @dir: containing directory object
>   * @qstr: unused
> - * @name: where to put the attribute name
> - * @value: where to put the attribute value
> - * @len: where to put the length of the attribute
> + * @xattrs: where to put the attribute
>   *
>   * Returns 0 if it all works out, -ENOMEM if there's no memory
>   */
>  static int smack_inode_init_security(struct inode *inode, struct inode *dir,
> -				     const struct qstr *qstr, const char **name,
> -				     void **value, size_t *len)
> +				     const struct qstr *qstr,
> +				     struct xattr *xattrs)
>  {
>  	struct inode_smack *issp = smack_inode(inode);
>  	struct smack_known *skp = smk_of_current();
>  	struct smack_known *isp = smk_of_inode(inode);
>  	struct smack_known *dsp = smk_of_inode(dir);
> +	struct xattr *xattr = NULL;
>  	int may;
>  
> -	if (name)
> -		*name = XATTR_SMACK_SUFFIX;
> +	if (xattrs)
> +		xattr = xattrs + smack_blob_sizes.lbs_xattr;
> +
> +	if (xattr) {
> +		xattr->name = XATTR_SMACK_SUFFIX;
>  
> -	if (value && len) {
>  		rcu_read_lock();
>  		may = smk_access_entry(skp->smk_known, dsp->smk_known,
>  				       &skp->smk_rules);
> @@ -976,11 +979,11 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
>  			issp->smk_flags |= SMK_INODE_CHANGED;
>  		}
>  
> -		*value = kstrdup(isp->smk_known, GFP_NOFS);
> -		if (*value == NULL)
> +		xattr->value = kstrdup(isp->smk_known, GFP_NOFS);
> +		if (xattr->value == NULL)
>  			return -ENOMEM;
>  
> -		*len = strlen(isp->smk_known);
> +		xattr->value_len = strlen(isp->smk_known);
>  	}
>  
>  	return 0;
> @@ -4785,6 +4788,7 @@ struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
>  	.lbs_ipc = sizeof(struct smack_known *),
>  	.lbs_msg_msg = sizeof(struct smack_known *),
>  	.lbs_superblock = sizeof(struct superblock_smack),
> +	.lbs_xattr = SMACK_INODE_INIT_XATTRS,
>  };
>  
>  static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel

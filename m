Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB19551997
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 16:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792083542; cv=none; b=nvGFbmlvsaQpDun7+0w7I3MQNJRgu/5H42Ttv725fMADKc/owiXimc5hWL1x0yFzrS9pb4Cy2dKV5rxfNy2XFc4RFIaDow+WrVdX+eFI/eNrlwftKs9Tj+DJs9nsrqJxxVjhZRfCYjeN4UkQvX6D19JqRE1GkHZ6VtQ/DzUNVt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792083542; c=relaxed/simple;
	bh=YzROl6vJA4Mn+TDlieovNm3NgImLMMW0O6JCegZ1Gp0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=sodpmze+5u4s90bee+jcYvmgLPAuh50v7u0BDO2JYYEqBJHVK3yM4zUgzQ+PL/aSrIXk96OnU7iigOt/9ui6f2KM5Lov9gpiBMGKEnS6A1CKG33sJQoAh5vJdejEInvig9SOKCPD9UwkmlYOMx6N+Tbm7W6HmkpTI+O5E+9w+wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eE7EaAjF; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eE7EaAjF"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e915887d9dso22000915ad.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 09:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792083525; x=1792688325; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OXYHFaEiq6VlF6l7OPxNq/0HouFXap07l9nlhMKXwLY=;
        b=eE7EaAjFyqXLngWvagkq1L4NPgL8UB3+TUBUc8hePMCz3AYTfQiCcsfOE7iDMuwLwD
         ikeXU3FLbPjWYIh892P442QamMj0Ntl2R3FeI1FUn1Wgn1GIKX2BIX1jf3WL0J72mtfp
         ZX/rctiVh2FGcxqig1siiVD6HoIdObFaWt8qapr+UKCGcW5p7L2/WWsG99+YmYr0NAD4
         EXQLfxprv1NaBsl/YlkDiSVpVWl0CQezQ4lUnmCC/uiAWgZTGIFUVrGwnGXMq4h7iIa5
         adr1k2YOJknHd3uxB4vArMPSvzo3ehnxWw70PHpB5keXNd5rVbb/QSZYBcz/c4hkHW6x
         CtDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792083525; x=1792688325;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OXYHFaEiq6VlF6l7OPxNq/0HouFXap07l9nlhMKXwLY=;
        b=bPqKDt1t8Ih0DnigJQKUXq0ycqJzoXq2yyNzebH2hKx9yb9FC8kus6IYZKTaXrb5Sc
         vlDcFT0SkXXkbqm1Qk3Mrq/QbJzs6rLC+Sj++P+iD5HCIhXi5t0Xo/jHS/+8qRgGi5oI
         9LK12EOD43L5KYInyursbnAlwfi6+Zph/9vEysEHBbQB+Oj5XcmEqlCqFtIuO7v8Moag
         a/WUxX9kKAWbN7pTVahUTvPJBZT1xOMH3fp0i7AuZKx3T/xslOaM6ruWQ435Z4m3dtZq
         TLLnbENiMBGe4USf8974ERjxnzunhShb13e2BbR78N6rV6odGH043ClF4YYYWNAdllzg
         nkAQ==
X-Gm-Message-State: AFq9FYIbpKdJuAR4AvovHCjQVB+AXCxAeG3dvMH/c9wzJOy3I9NxKg1E
	uz6UtwXj3h9m3YovViFZAHEytFJam48lS/SnNbU5jFjWKJOlIcAq3HT4
X-Gm-Gg: AYBFou0yxkEveKE6Z4eZchB58iyAis/jeT2Nv/lLYOxSwgYDSfCl5PpD01dOocjBiNY
	2TLtRHPKnxCOaxdXnnQC9ZPmvIOdwdc9V6ZVAxRXbbQiMXp/lrn4KHZZVUA639kiP/Rx2t+rK/D
	RLuih3yIYAcmFXJXZr2uc3hTflUo5HrX0cuTJh3ryDt6KaANSgdI3v5bBguDLd4mqqHNc/bGJRm
	J7BeSPuLZkdcId7Dv9QZW3cvkhb0pB2OfOr8yU1DKUQ0rnOGGMj5TfzxbznMh5yrbaTVBz5RQ2/
	aQMcCtK3bkH8YuuAHnvT+6YfmooMQVGKp0hI2Ut3O1+TyTYzqcSY9pYY8MVVViKkpYb9VK0RGZq
	9u5dWq+bMKBYZAilR6he6HAdEcLOU+RbMTzKIVWRwu1yAl6ldCNofOvcubUQZVbOm2pHMyCV3SD
	16Njzyh045ACLqwZtls+4X/KNmv0mb2DJWtlAYAYgBGtva9rRZyMvrj7OYhQn2a9pp8A==
X-Received: by 2002:a17:903:19cf:b0:2dd:ad73:c989 with SMTP id d9443c01a7336-2e842bc7fa7mr166412235ad.33.1792083524573;
        Thu, 15 Oct 2026 09:58:44 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422e1643sm87050475ad.70.2026.10.15.09.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 09:58:44 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	akpm@linux-foundation.org,
	zzzccc427@gmail.com,
	ericterminal@gmail.com,
	christophe.jaillet@wanadoo.fr,
	kees@kernel.org,
	kmehltretter@gmail.com,
	sunil.mushran@oracle.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com
Subject: [PATCH] ocfs2/cluster: Initialize heartbeat regions before publishing them
Date: Fri, 16 Oct 2026 00:58:38 +0800
Message-Id: <pm-ocfs2-objects-candidate-0079-v5-f931a29339cadc0a2a70@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A region on o2hb_all_regions must have an initialized config item and
name. o2hb_heartbeat_group_make_item() currently links the zeroed region
under o2hb_live_lock, drops the lock, and only then initializes hr_item.
The lock therefore protects the list without protecting initialization
from readers of the published item.

With global heartbeat enabled, a DLM_QUERY_REGION from the current
joining node can pass the existing-domain and protocol checks while a
configfs mkdir creates another region. The DLM locks are not taken by
the constructor, and the network worker does not take the configfs
subsystem mutex. The following ordering is possible:

  Configfs mkdir                     O2net receive worker
  --------------                     --------------------
  Allocate reg
  Lock o2hb_live_lock
  Link into o2hb_all_regions
  Unlock o2hb_live_lock
                                     dlm_query_region_handler()
                                       dlm_match_regions()
                                         o2hb_get_all_regions()
                                           Lock o2hb_live_lock
                                           Copy 32 bytes from NULL name
                                           Unlock o2hb_live_lock
  config_item_init_type_name()

The query thus dereferences NULL. Initialize hr_item before linking the
region so the existing list lock also orders name initialization before
any reader. Reject a failed name allocation, since the initialization
helper does not propagate that error.

Use config_item_put() on initialized constructor failures to release the
name and respect references retained by o2hb_region_pin(). Initialize
the list heads, mutex and delayed works needed by o2hb_region_release()
before any such put, and leave the list node self-linked after rollback.
Keep the existing handler drain before removing a failed published item.

KASAN report as below:

    ==================================================================
    BUG: KASAN: null-ptr-deref in o2hb_get_all_regions+0xbb/0x1f0
    Read of size 32 at addr 0000000000000000 by task kworker/u16:1/14

    CPU: 2 UID: 0 PID: 14 Comm: kworker/u16:1 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: o2net o2net_rx_until_empty
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     kasan_report+0xe0/0x110
     ? o2hb_get_all_regions+0xbb/0x1f0
     kasan_check_range+0x105/0x1b0
     __asan_memcpy+0x23/0x60
     o2hb_get_all_regions+0xbb/0x1f0
     dlm_query_region_handler+0x4c2/0xc20
     ? __pfx_dlm_query_region_handler+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? kvm_clock_get_cycles+0x31/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_dlm_query_region_handler+0x10/0x10
     o2net_rx_until_empty+0x1a50/0x3200
     ? reacquire_held_locks+0xdd/0x200
     ? __pfx_o2net_rx_until_empty+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? process_one_work+0x935/0x1b40
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_worker_thread+0x10/0x10
     kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>
    ==================================================================

Fixes: 536f0741f324 ("ocfs2/cluster: Track number of global heartbeat regions")
Cc: <stable@vger.kernel.org>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM

---
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 8e6ead433228..9a4703bdc4e8 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2140,6 +2140,18 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	}
 	reg->hr_node_num = O2NM_MAX_NODES;
 
+	INIT_LIST_HEAD(&reg->hr_all_item);
+	mutex_init(&reg->hr_arming_mutex);
+	reg->hr_stopping = true;
+	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
+	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
+	INIT_LIST_HEAD(&reg->hr_handler_list);
+	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
+	if (!config_item_name(&reg->hr_item)) {
+		ret = -ENOMEM;
+		goto put_item;
+	}
+
 	spin_lock(&o2hb_live_lock);
 	reg->hr_region_num = 0;
 	if (o2hb_global_heartbeat_active()) {
@@ -2148,26 +2160,19 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 		if (reg->hr_region_num >= O2NM_MAX_REGIONS) {
 			spin_unlock(&o2hb_live_lock);
 			ret = -EFBIG;
-			goto free;
+			goto put_item;
 		}
 		set_bit(reg->hr_region_num, o2hb_region_bitmap);
 	}
 	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
 	spin_unlock(&o2hb_live_lock);
 
-	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
-
 	/* this is the same way to generate msg key as dlm, for local heartbeat,
 	 * name is also the same, so make initial crc value different to avoid
 	 * message key conflict.
 	 */
 	reg->hr_key = crc32_le(reg->hr_region_num + O2NM_MAX_REGIONS,
 		name, strlen(name));
-	mutex_init(&reg->hr_arming_mutex);
-	reg->hr_stopping = true;
-	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
-	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
-	INIT_LIST_HEAD(&reg->hr_handler_list);
 	ret = o2net_register_handler(O2HB_NEGO_TIMEOUT_MSG, reg->hr_key,
 			sizeof(struct o2hb_nego_msg),
 			o2hb_nego_timeout_handler,
@@ -2190,10 +2195,13 @@ unregister_handler:
 	o2net_unregister_and_flush_handler_list(&reg->hr_handler_list);
 remove_item:
 	spin_lock(&o2hb_live_lock);
-	list_del(&reg->hr_all_item);
+	list_del_init(&reg->hr_all_item);
 	if (o2hb_global_heartbeat_active())
 		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
 	spin_unlock(&o2hb_live_lock);
+put_item:
+	config_item_put(&reg->hr_item);
+	return ERR_PTR(ret);
 free:
 	kfree(reg);
 	return ERR_PTR(ret);

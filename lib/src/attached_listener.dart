part of databinder;

class _AttachedListener {
  EventListenerList list;
  EventListener listener;

  _AttachedListener(this.list, this.listener);

  deattach(){
    list.remove(listener);
  }

  attach(){
    list.add(listener);
  }
}